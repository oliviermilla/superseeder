module Superseeder
  module Seedable

    def seed(*args, &block)
      opts = args.extract_options!
      path = if opts[:path].blank?
               Rails.root.join('db', 'seeds', 'data')
             else
               Pathname(opts.delete :path)
             end
      filename = opts.delete :filename
      path = if filename.blank?
               tmp = path.join "#{self.name.underscore.pluralize}*"
               candidates = Dir.glob tmp
               raise ArgumentError.new "Multiple candidate files for #{self.name}: #{candidates}, either leave one candidate file or specify the filename you want to use with the :filename option." if candidates.length > 1
               raise ArgumentError.new "No candidate files for #{self.name}. Either create a #{tmp} file or specify the filename you want to use with the :filename option." if candidates.length == 0
               candidates.first
             else
               tmp = path.join filename
               raise ArgumentError.new "#{filename} does not exist." unless File.exist? tmp
               tmp
             end
      ext = File.extname path
      Dir[Pathname(Gem::Specification.find_by_name('superseeder').gem_dir).join('lib','superseeder','formats','*.rb')].each{ |f| require(f) }
      modules = Superseeder::Formats.constants.select{ |c| Module === Superseeder::Formats.const_get(c) }.map{ |c| Superseeder::Formats.const_get(c) }
      mod = modules.find{ |m| m.send(:extensions).include? ext }
      raise ArgumentError.new "No registered module to support #{ext} extension." if mod.nil?
      Rails.logger.debug "Seeding #{self.name.downcase.pluralize.humanize} from #{path}..."
      count = self.count
      self.extend mod
      self.__process path, opts, &block
      Rails.logger.debug "Done. (#{self.count - count} entries added)"
    end
  end

end