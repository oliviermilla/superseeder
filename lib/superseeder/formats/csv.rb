module Superseeder
  module Formats
    module Csv

      def self.extensions
        %w(.csv)
      end

      def __process(path, *args)
        require 'csv'
        opts = args.extract_options!
        ::CSV.foreach(path, :headers => true, :col_sep => opts.delete(:col_sep) || ';') do |row|
          row = row.to_hash
          if block_given?
            yield row, opts
          else
            instance = self.new

            # Set relations
            instance.class.reflections.each do |key, val|
              attrs = row.select{ |k, _| k =~ /\A#{key}_/ }
              next if attrs.empty?
              case val[:macro]
                when :belongs_to, :embedded_in
                  instance.send "#{key}=", val[:class_name].find_by(attrs)
                when :has_many, :embeds_many
                  instance
                when :has_and_belongs_to_many
                else
                  instance #Should never happen
              end
            end

            # Set attributes
            instance.fields.each do |attr, _|
              instance.send "#{attr}=", row[attr] unless attr == '_id'
            end

            instance.save!
          end
        end
      end

    end

  end
end