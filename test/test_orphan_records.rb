require_relative 'test_helper.rb'

describe "when asked for get_schema_info" do
  it "must create and return the TableInfo values" do
    OrphanRecords.get_schema_info("table_name").must_be_instance_of(TableInfo)
  end
end  

describe "when asked for create_association_info" do
  it "must create and return the associations details" do
    attrs = []
    table_infos = []
    attrs << Attribute.new("title", "asd", "qwe", true)
    table_infos << TableInfo.new("Table1", attrs)
    attrs = []
    attrs << Attribute.new("table1_id", "asd", "qwe", true)
    table_infos << TableInfo.new("Table2", attrs)
    associations = OrphanRecords.create_association_info(table_infos)
    associations.count.must_equal(1)
    attributes = associations.first.attr
    assert_equal attributes.name, 'table1_id'
    assert_equal attributes.type, 'asd'
    assert_equal attributes.default, 'qwe'
    assert_equal associations.first.node1, table_infos.last
    assert_equal associations.first.node2, table_infos.first
  end
end

