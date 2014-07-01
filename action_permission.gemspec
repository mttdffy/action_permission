# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'action_permission/version'

Gem::Specification.new do |spec|
  spec.name          = "action_permission"
  spec.version       = ActionPermission::VERSION
  spec.authors       = ["Matt Duffy", "Brian McElaney", "Mark Platt"]
  spec.email         = ["matt@mttdffy.com", "", ""]
  spec.summary       = "Controller-based action and attribute permissions"
  spec.homepage      = "https://github.com/mttdffy/action_permission"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", "~> 4.0.0"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2"
  spec.add_development_dependency "activerecord-nulldb-adapter"
end
