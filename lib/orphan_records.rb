require File.join(Rails.root, "config/environment")

MODEL_DIR   = File.join(Rails.root, "app/models")
FIXTURE_DIR = File.join(Rails.root, "test/fixtures")

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

    assocs.each do | assoc |
      puts "\t\"#{assoc.node1.name}\" -> \"#{assoc.node2.name}\" [label=\"#{assoc.attr.name}\"]\n"
    end
  end

  # We're passed a name of things that might be 
  # ActiveRecord models. If we can find the class, and
  # if its a subclass of ActiveRecord::Base,
  # then pass it to the associated block
  def self.execute
    tableInfos = []
    ActiveRecord::Base.connection.tables.each do |table_name|
      puts "Looking at table: #{table_name}"
      tableInfos << get_schema_info(table_name)
    end
    
    create_association_info(tableInfos)
  end
end
