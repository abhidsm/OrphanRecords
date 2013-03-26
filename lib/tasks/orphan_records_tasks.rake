desc "Orphan Records"
namespace :orphan_records do
  desc "Show the orphan records"
  task :show do
   require File.join(File.dirname(__FILE__), "../orphan_records.rb")
   OrphanRecords.find_orphan_records
  end

  desc "Delete the orphan records"
  task :delete do
   require File.join(File.dirname(__FILE__), "../orphan_records.rb")
   OrphanRecords.delete_orphan_records
  end
end
