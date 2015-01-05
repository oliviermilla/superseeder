require '../../test_helper'
require 'superseeder/seedable'

describe '#seed' do
  Parking.extend ::Superseeder::Seedable
  Car.extend ::Superseeder::Seedable

  describe 'with csv format' do

    { Parking => [%w(parkings_without_cars.csv parkings_with_cars.csv), 4],
      Car => [%w(cars_with_parkings.csv cars_without_parkings.csv), 3] }.each do |klass, (filenames, count)|
      describe "seeds all the #{klass} rows" do
        filenames.each do |filename|
          it "from #{filename}" do
            klass.seed :filename => filename
            assert_equal count, klass.count
          end
        end
      end
    end

    describe 'with no relation' do
      it 'sets the values' do
        Parking.seed :filename => 'parkings_without_cars.csv'
        assert_equal %w(South North East West).sort, Parking.all.map(&:name).sort
      end
    end

    describe 'with single relations' do
      before :each do
        Parking.seed :filename => 'parkings_without_cars.csv'
      end

      it 'sets the relations' do
        Car.seed :filename => 'cars_with_parkings.csv'
        Car.all.entries.each do |car|
          assert_kind_of Parking, car.parking
        end
      end
    end
  end

  describe 'with multiple relations' do
    before :each do
      Car.seed :filename => 'cars_without_parkings.csv'
    end

    it 'sets the relations' do
      Parking.seed :filename => 'parkings_with_cars.csv'
      Car.all.entries.each do |car|
        assert_kind_of Parking, car.parking
      end
    end
  end

end