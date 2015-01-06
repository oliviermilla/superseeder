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
        update = opts.delete :update_by

        s = EXTENSIONS[File.extname(path)].constantize.new path.to_s, opts
        header = s.row s.first_row
        for index in (s.first_row + 1..s.last_row)
          row = s.row index
          row = header.each_with_index.inject(Hash.new){ |stamp, (i, idx)| stamp[i] = row[idx]; stamp }
          row = row.with_indifferent_access
          if block_given?
            yield row
          else
            instance = row['_type'].blank? ? self : row['_type'].constantize
            instance = if update
                         i = instance.find_by(update => row[update])
                         i || instance.new
                       else
                         instance.new
                       end

            require 'superseeder/adapter'
            adapter = ::Superseeder::Adapter.new instance

            save_relations = []
            # Set relations
            adapter.each_relation do |name, is_array, class_name|
              attrs = row.select{ |k, _| k =~ /\A#{name}_/ }
              next if attrs.empty?
              attrs = attrs.inject({}){ |h, (k, v)| h[k.sub /\A#{name}_/, ''] = v; h }
              if is_array
                vals = attrs.map do |k, v|
                  v.split(many_sep).map{ |u| class_name.find_by k => u } unless v.nil?
                end
                vals.flatten!
                vals.compact!
                vals = vals | instance.send(name)
                instance.send "#{name}=", vals
                save_relations.concat vals if defined? Mongoid::Document && instance.kind_of?(Mongoid::Document) # Not really nice, TODO FIX through adapter
              else
                instance.send "#{name}=", class_name.find_by(attrs)
              end
            end

            # Set fields
            adapter.each_field(row) do |name, is_array|
              val = if is_array
                      row[name].try(:split, many_sep)
                    else
                      row[name]
                    end
              instance.send "#{name}=", val
            end

            if instance.valid?
              instance.save if instance.changed?
              save_relations.uniq!
              save_relations.each(&:save)
            else
              Rails.logger.debug "Skipped #{row} : #{instance.errors.full_messages}"
            end
          end
        end
      end
    end
  end
end