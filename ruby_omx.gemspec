$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ruby_omx/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ruby_omx"
  s.version     = RubyOmx::VERSION
  s.authors     = ["A. Edward Wible"]
  s.email       = ["aewiblee@gmail.com"]
  s.homepage    = "http://github.com/aew/ruby_omx"
  s.summary     = "Ruby wrapper for OrderMotion (OMX)"
  s.description = "Ruby wrapper for OrderMotion (OMX) developer API"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  #s.add_dependency "ruby-hmac", "~> 0.4.0"
  s.add_dependency "roxml", "~> 3.3.1"
  s.add_dependency "xml-simple", "~> 1.1.1"
  s.add_dependency "builder", "~> 3.0.0"
end
