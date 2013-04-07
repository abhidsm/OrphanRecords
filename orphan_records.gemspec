Gem::Specification.new do |s|
  s.name = 'orphan_records'
  s.version = "0.0.3"

  s.authors = [%q{abhilash}]
  s.date = %q{2013-04-07}
  s.description = %q{Show/Delete Orphan Records in your Rails application}
  s.email = %q{abhidsm@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md",
    "README"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "README",
    "Rakefile",
    "lib/orphan_records.rb",
    "lib/orphan_records/railtie.rb",
    "lib/tasks/orphan_records_tasks.rake",
    "test/test_helper.rb",
    "test/test_orphan_records.rb",
    "orphan_records.gemspec"
  ]
  s.homepage = %q{https://github.com/abhidsm/OrphanRecords}
  s.licenses = [%q{Ruby}]
  s.require_paths = [%q{lib}]
  s.summary = %q{Show/Delete Orphan Records in your Rails application}
  s.test_files = [
    "test/test_helper.rb",
    "test/test_orphan_records.rb"
  ]
end
