module Superseeder
  module Formats
    module Yaml

      def self.extensions
        %w(.yml .yaml)
      end

      def __process(path, *args)
        require 'yaml'
        f = YAML.load_file(path)
        yield f
      end

    end
  end
end