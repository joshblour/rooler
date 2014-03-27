$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rooler/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rooler"
  s.version     = Rooler::VERSION
  s.authors     = ["Yonah Forst"]
  s.email       = ['joshblour@hotmail.com']
  s.homepage    = "http://www.github.com/joshblour"
  s.summary     = "mailer triggered by klass rules"
  s.description = "send emails based on results of a class method"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_runtime_dependency 'rails', '~> 4.0', '>= 4.0.1'
  s.add_runtime_dependency 'liquid', '~> 2.6', '>= 2.6.1'
  s.add_runtime_dependency 'ckeditor', '~> 4.0', '>= 4.0.10'
  s.add_runtime_dependency 'simple_form', '~> 3.0', '>= 3.0.1'
  s.add_runtime_dependency 'rubytree', '~> 0.9', '>= 0.9.3'

  s.add_development_dependency 'pg'
  s.add_development_dependency 'factory_girl_rails'
end
