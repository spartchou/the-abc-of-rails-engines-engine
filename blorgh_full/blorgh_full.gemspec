$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "blorgh_full/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "blorgh_full"
  s.version     = BlorghFull::VERSION
  s.authors     = ["spartchou"]
  s.email       = ["spart.chou@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of BlorghFull."
  s.description = "TODO: Description of BlorghFull."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.10"

  s.add_development_dependency "sqlite3"
end
