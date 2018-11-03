$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "omg_image/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "omg_image"
  s.version     = OmgImage::VERSION
  s.authors     = ["Igor Kasyanchuk"]
  s.email       = ["igorkasyanchuk@gmail.com"]
  s.homepage    = "https://github.com/igorkasyanchuk/omg_image"
  s.summary     = "Summary of OmgImage."
  s.description = "Description of OmgImage."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 5.0.0"
  s.add_dependency "open4"
  s.add_dependency "better_tempfile"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "puma"
  s.add_development_dependency "pry"
end
