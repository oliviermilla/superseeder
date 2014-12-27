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
              attrs = attrs.inject({}){ |h, (k, v)| h[k.sub /\A#{key}_/, ''] = v; h }
              if [Mongoid::Relations::Referenced::Many,
                  Mongoid::Relations::Embedded::Many,
                  Mongoid::Relations::Referenced::ManyToMany].include? val[:relation]
                vals = attrs.map do |k, v|
                  v.split(opts[:many_sep] || ',').map{ val.class_name.constantize.find_by k => v } unless v.nil?
                end
                vals.flatten!
                vals.compact!
                instance.send "#{key}=", vals
              else
                instance.send "#{key}=", val.class_name.constantize.find_by(attrs)
              end
            end

            # Set attributes
            instance.fields.select{ |f, _| row.key? f }.each do |name, field|
              val = if field.type == Array
                      row[name].try(:split, opts[:many_sep] || ',')
                    else
                      row[name]
                    end
              instance.send "#{name}=", val
            end

            if instance.valid?
              instance.save
            else
              logger.debug "Skipped #{row} : #{instance.errors.full_messages}"
            end
          end
        end
      end

    end
  end
end