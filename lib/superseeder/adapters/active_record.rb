module Superseeder
  module Adapters
    module ActiveRecord

      def each_relation
        self.instance.singleton_class.reflections.each do |key, val|
          yield key, self.is_array_relation?(val), val.class_name.constantize
        end
      end

      def each_field(row)
        self.instance.attributes.each do |field, val|
          next unless row.key? field
          yield field, false, false #self.is_array_field?(options) TODO inquiry
        end
      end

      protected

      def is_array_field?(options)
        options.type == Array
      end

      def is_hash_field?(options)
        options.type == Hash
      end

      def is_array_relation?(reflection)
        [::ActiveRecord::Reflection::HasManyReflection,
         ::ActiveRecord::Reflection::HasAndBelongsToManyReflection].any?{ |c| reflection.kind_of? c }
      end

    end
  end
end