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
  spec.homepage      = "https://github.com/tamman/action_parameter"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "actionpack", "~> 4.0"
  spec.add_dependency "strong_parameters", "~> 0.2"
  spec.add_dependency "railties", "~> 4.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
