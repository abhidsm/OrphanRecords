require 'rubygems'
require 'bundler'
require 'active_support'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

module Rails
  def self.env
    ActiveSupport::StringInquirer.new("test")
  end

  def self.root
    "test"
  end
end

class File
  def self.join(first, second)
    "minitest/spec"
  end
end

module ActiveRecord
  class Column
    def type
      "type"
    end
    def limit
      12
    end
    def name
      "asd"
    end
    def default
      "default"
    end
    def null
    end
  end
  
  class Table
    def tables
      [Table.new, Table.new]
    end
    def columns(name)
      [Column.new, Column.new]
    end
  end
  
  class Base
    def self.connection
      Table.new
    end
  end
end

require 'minitest/spec'
require 'minitest/autorun'
require_relative "../lib/orphan_records"

