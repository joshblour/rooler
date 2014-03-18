$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rooler/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rooler"
  s.version     = Rooler::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Rooler."
  s.description = "TODO: Description of Rooler."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.1"
  s.add_dependency "liquid", "~> 2.6.1"
  s.add_dependency "ckeditor", "~> 4.0.10"
  s.add_dependency 'simple_form'

  s.add_development_dependency "pg"
  s.add_development_dependency 'factory_girl_rails'
end
