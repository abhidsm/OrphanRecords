require 'orphan_records'
require 'rails'
module OrphanRecords
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.join(File.dirname(__FILE__), "../tasks/orphan_records_tasks.rake")
    end
  end
end
