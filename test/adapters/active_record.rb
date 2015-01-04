require 'active_record'

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'

load File.dirname(__FILE__) + '/schema.rb'


class Car < ActiveRecord::Base

  belongs_to :parking

  validates :name, :presence => true
end

class Parking

  has_many :cars

  validates :name, :presence => true, :uniqueness => true
end