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
            yield row, opts
          else
            instance = row['_type'].blank? ? self : row['_type'].constantize
            update_by = opts[:update_by]
            instance = if update_by
                         if update_by.kind_of? Proc
                           i = update_by.call(instance, row)
                           i || instance.new
                         end
                         if update_by.kind_of? Array
                           i = self.all
                           update_by.each do |u|
                             i = i.where u => row[u]
                           end
                           i = i.entries
                           raise ArgumentError.new ":update_by => #{update_by} yielded more than one record!" if i.length > 1
                           i.first || instance.new
                         else
                           i = instance.find_by update_by => row[update_by]
                           i || instance.new
                         end
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
            adapter.each_field(row) do |name, is_array, is_hash|
              val = if is_array
                      row[name].try(:split, many_sep)
                    elsif is_hash
                      eval row[name] if row[name]
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
              puts "Skipped #{row} : #{instance.errors.full_messages}" if ::Superseeder.verbose?
            end
          end
        end
      end
    end
  end
end