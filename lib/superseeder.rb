module Superseeder

  def seed(symbol, *args, &block)
    require 'superseeder/seedable'
    klass = symbol.to_s.classify.constantize
    klass.extend Superseeder::Seedable
    klass.seed *args, &block
  end

end