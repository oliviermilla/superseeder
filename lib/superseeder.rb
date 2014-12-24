module Superseeder

  def seed(symbol, *args)
    require 'superseeder/seedable'
    klass =symbol.to_s.classify.constantize
    klass.extend Superseeder::Seedable
    klass.seed *args
  end

end