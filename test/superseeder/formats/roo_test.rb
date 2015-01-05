require '../../test_helper'
require 'superseeder/seedable'

describe '#seed' do
  Parking.extend ::Superseeder::Seedable

  describe 'with csv format' do

    it 'seeds the database' do
      Parking.seed
      assert_equal 4, Parking.count
    end
  end

end