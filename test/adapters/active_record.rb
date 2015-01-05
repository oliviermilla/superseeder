require 'active_record'
require 'rake'

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'

class Car < ActiveRecord::Base

  belongs_to :parking

  validates :name, :presence => true
end

class Parking < ActiveRecord::Base

  has_many :cars

  validates :name, :presence => true, :uniqueness => true
end

load File.dirname(__FILE__) + '/schema.rb'
#ActiveRecord::Tasks::DatabaseTasks.migrate
#Rake.load_rakefile 'active_record/railties/databases.rake'
#require 'active_record/railties/databases.rake'
#Rake::Task['db:migrate'].invoke

require_relative 'all'