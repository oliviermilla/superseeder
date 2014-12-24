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
  s.summary     = 'Superseeder helps you manage small and big seeds.'
  s.description = 'Superseeder was designed to properly manage large seeds in a simple way.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '~> 4'
end
