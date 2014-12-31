module Superseeder
  module Formats
    module Roo

      EXTENSIONS = { '.csv'   => '::Roo::CSV',
                     '.xls'   => '::Roo::Excel',
                     '.xlsx'  => '::Roo::Excelx',
                     '.ods'   => '::Roo::OpenOffice'
      }

      def self.extensions
        EXTENSIONS.keys
      end

      def __process(path, *args)
        require 'roo'

        opts = args.extract_options!
        many_sep = opts.delete(opts[:many_sep]) || ','

        s = EXTENSIONS[File.extname(path)].constantize.new path.to_s, opts
        header = s.row s.first_row
        for index in (s.first_row + 1..s.last_row)
          row = s.row index
          row = header.each_with_index.inject(Hash.new){ |stamp, (i, idx)| stamp[i] = row[idx]; stamp }
          row = row.with_indifferent_access
          if block_given?
            yield row
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
                  v.split(many_sep).map{ val.class_name.constantize.find_by k => v } unless v.nil?
                end
                vals.flatten!
                vals.compact!
                instance.send "#{key}=", vals
              else
                instance.send "#{key}=", val.class_name.constantize.find_by(attrs)
              end
            end

            # Set attributes
            instance.fields.select{ |f, o| row.key? o.options[:as] || f }.each do |f, o|
              name = o.options[:as] || f
              val = if o.type == Array
                      row[name].try(:split, many_sep)
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