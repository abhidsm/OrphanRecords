require 'rubygems'
require 'active_support/all'

TableInfo = Struct.new(:name, :attributes)
Attribute = Struct.new(:name, :type, :default, :isnull)
Association = Struct.new(:attr, :node1, :node2)

module OrphanRecords

  # Use the column information in an ActiveRecord class
  # to create an 'Attribute' for each column.
  # The line contains the column name, the type
  # (and length), and any optional attributes
  def self.get_schema_info(table_name)
    attrs = []
    ActiveRecord::Base.connection.columns(table_name).each do |col|
      col_type = col.type.to_s
      col_type << "(#{col.limit})" if col.limit
    
      attrs << Attribute.new(col.name, col_type, col.default, !col.null)
    end

    return TableInfo.new(ActiveSupport::Inflector.classify(table_name), attrs)
  end


  def self.create_association_info(tableInfos)
    assocs = []
    # Draw the tables as boxes
    tableInfos.each do |table |
      attrs = ""
      table.attributes.each do | attr |
        if attr.name =~ /\_id$/
          # Create an association to other table
          table_name = ActiveSupport::Inflector.camelize(attr.name.sub(/\_id$/, ''))
          other_table = tableInfos.find { | other | other.name == table_name }
          assocs << Association.new(attr, table, other_table) if other_table != nil
        end
        attrs << "#{attr.name} : #{attr.type}"
        attrs << ", default: \\\"#{attr.default}\\\"" if attr.default
        attrs << "\\n"
      end
    end

    assocs
  end

  # We're passed a name of things that might be 
  # ActiveRecord models. If we can find the class, and
  # if its a subclass of ActiveRecord::Base,
  # then pass it to the associated block
  def self.get_associations
    tableInfos = []
    configurations = YAML::load(File.open(File.join(Rails.root, "config/database.yml")))
    ActiveRecord::Base.establish_connection configurations[Rails.env]
    ActiveRecord::Base.connection.tables.each do |table_name|
      # puts "Looking at table: #{table_name}"
      tableInfos << get_schema_info(table_name)
    end
    
    create_association_info(tableInfos)
  end

  def self.find_orphan_records(options = {:delete => false})
    require File.join(Rails.root, "config/environment")
    associations = get_associations
    associations.each do | assoc |
      # puts "\t\"#{assoc.node1.name}\" -> \"#{assoc.node2.name}\" [label=\"#{assoc.attr.name}\"]\n"
      begin
        model = eval(assoc.node1.name)
        model.all.each do |obj|
          id = obj.send(assoc.attr.name)
          record = eval(assoc.node2.name).find_by_id(id)
          if(record.nil?)
            puts "\t\"#{assoc.node1.name} ID: #{obj.id} associated with #{assoc.node2.name} ID: #{id} which doesn't exist"
            if(options[:delete])
              obj.delete
              puts "\t\"#{assoc.node1.name} ID: #{obj.id} deleted"
            end
          end
        end
      rescue Exception => e
        # puts "\t\t\"#{e.message}"
      end
    end
  end

  def self.delete_orphan_records
    find_orphan_records({:delete => true})
  end

end

require File.join(File.dirname(__FILE__), "orphan_records/railtie") if defined?(Rails)

