require '../test_helper'

# Create a fake format taking the .wxwxwx extension that do nothing to
# test Superseeder::#seed without it actually performing anything
module ::Superseeder
  module Formats
    module TestFormat

      def self.extensions
        %w(.wxwxwx)
      end

      def __process(path, *args)
        #Do nothing
      end

    end
  end
end

describe '#seed' do

  @@class = Class.new do
    include ::Superseeder
  end

  let(:object){ @@class.new }

  it 'extend the class with the format\'s module when the file is found' do
    object.seed :whatever
    assert_kind_of ::Superseeder::Formats::TestFormat, Whatever
  end

  describe 'with multiple candidate files' do
    it 'raises an error if :filename is not specified' do
      assert_raises(ArgumentError){ object.seed :multiple }
    end
    describe 'with :filename specified' do
      it 'raises an error when the filename does not match any file' do
        assert_raises(ArgumentError){ object.seed :multiple, :filename => 'multiple.wxwxwx' }
      end
    end
  end

  it 'raises an error when no candidate file is found' do
    assert_raises(ArgumentError){ object.seed :nofile }
  end

  it 'raises an error when the file format is not supported by any module' do
    assert_raises(ArgumentError){ object.seed :noformat }
  end

end

