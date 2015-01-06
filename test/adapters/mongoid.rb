require 'mongoid'

Mongoid.load! 'test/adapters/mongoid.yml', :test
Mongoid.raise_not_found_error = false

class Car
  include Mongoid::Document

  field :name, :type => String

  belongs_to :parking

  validates :name, :presence => true
end

class Parking
  include Mongoid::Document

  field :name, :type => String
  field :size, :type => Integer

  has_many :cars

  validates :name, :presence => true, :uniqueness => true
end

require_relative 'all'