module Superseeder
  class Adapter


    def self.adapters
      %w(active_record mongoid)
    end

    def initialize(instance)
      @instance = instance
      if defined? ActiveRecord::Base
        if instance.kind_of? ActiveRecord::Base
          require 'superseeder/adapters/active_record'
          self.singleton_class.include ::Superseeder::Adapters::ActiveRecord
        end
      end
      if defined? Mongoid::Document
        if instance.kind_of? Mongoid::Document
          require 'superseeder/adapters/mongoid'
          self.singleton_class.include ::Superseeder::Adapters::Mongoid
        end
      end
    end

    protected

    attr_reader :instance

  end
end