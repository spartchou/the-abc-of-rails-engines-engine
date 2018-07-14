$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "blorgh_default/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "blorgh_default"
  s.version     = BlorghDefault::VERSION
  s.authors     = ["spartchou"]
  s.email       = ["spart.chou@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of BlorghDefault."
  s.description = "TODO: Description of BlorghDefault."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"

  s.add_development_dependency "sqlite3"
end
