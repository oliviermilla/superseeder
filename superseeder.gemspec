$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'superseeder/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'superseeder'
  s.version     = Superseeder::VERSION
  s.authors     = ['Olivier Milla']
  s.email       = ['olivier.milla@gmail.com']
  s.homepage    = 'http://github.com/muichkine/superseeder'
  s.summary     = 'Easily seed your Rails models from sheet files.'
  s.description = 'Superseeder simplifies writing and managing seeds for Rails models in many different file formats.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '~> 4'
  s.add_dependency 'roo', '~>1'

  s.add_development_dependency 'sqlite3', '>=1.3.10'
  s.add_development_dependency 'mongoid', '~>4'
end
