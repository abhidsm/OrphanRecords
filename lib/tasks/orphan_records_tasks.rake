desc "Orphan Records"
namespace :orphan_records do
  desc "Show the orphan records"
  task :show do
   require File.join(File.dirname(__FILE__), "../orphan_records.rb")
   OrphanRecords.execute
  end
end
