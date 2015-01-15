# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'confident/version'

Gem::Specification.new do |spec|
  spec.name          = "confident_ruby"
  spec.version       = Confident::VERSION
  spec.authors       = ["Alexey Fedorov"]
  spec.email         = ["waterlink000@gmail.com"]
  spec.summary       = %q{Be confident and narrative when writing code in ruby.}
  spec.description   = %q{Gem contains useful abstractions for eliminating most condition and switch smells, treating anything just like a duck, implementing barricade and null object pattern efficiently.}
  spec.homepage      = "https://github.com/waterlink/confident.ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
