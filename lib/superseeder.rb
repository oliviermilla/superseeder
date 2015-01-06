module Superseeder

  def self.configure
    yield self
  end

  def self.verbose!
    @@verbose = true
  end

  def verbose?
    @@verbose ||= false
  end

  def seed(symbol, *args, &block)
    require 'superseeder/seedable'
    klass = symbol.to_s.classify.constantize
    klass.extend Superseeder::Seedable
    klass.seed *args, &block
  end

end