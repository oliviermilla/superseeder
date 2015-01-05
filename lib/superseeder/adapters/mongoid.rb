module Superseeder
  module Adapters
    module Mongoid

      def each_relation
        self.instance.singleton_class.reflections.each do |key, val|
          yield key, self.is_array_relation?(val), val.class_name.constantize
        end
      end

      def each_field(row)
        self.instance.fields.select{ |f, o| row.key? o.options[:as] || f }.each do |field, options|
          yield options.options[:as] || field, self.is_array_field?(options)
        end
      end

      protected

      def is_array_field?(options)
        options.type == Array
      end

      def is_array_relation?(options)
        [::Mongoid::Relations::Referenced::Many,
         ::Mongoid::Relations::Embedded::Many,
         ::Mongoid::Relations::Referenced::ManyToMany].include? options[:relation]
      end

    end
  end
end