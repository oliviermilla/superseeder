module Superseeder
  module Formats
    module Yaml

      def self.extensions
        %w(.yml .yaml)
      end

      def __process(path, *args)
        require 'yaml'
        opts = args.extract_options!

        f = YAML.load_file(path)
        yield f, opts
      end

    end
  end
end