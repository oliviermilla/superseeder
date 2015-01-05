require 'mongoid'

Mongoid.load 'spec/support/adapters/mongoid.yml', :test

class Car
  include Mongoid::Document

  field :name, :type => String

  belongs_to :parking

  validates :name, :presence => true
end

class Parking
  include Mongoid::Document

  field :name, :type => String
  has_many :cars

  validates :name, :presence => true, :uniqueness => true
end

require_relative 'all'