# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stormpath/rails/version'

Gem::Specification.new do |spec|
  spec.name          = "stormpath-rails"
  spec.version       = Stormpath::Rails::VERSION
  spec.authors       = ["Nenad Nikolic"]
  spec.email         = ["nenad.nikolic@infinum.hr"]

  spec.summary       = %q{TODO: Write a short summary, because Rubygems requires one.}
  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  spec.summary       = %q{Stormpath Rails integration}
  spec.description   = %q{Stormpath Rails integration}
  spec.homepage      = 'http://www.stormpath.com'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'stormpath-sdk', '>= 1.0.0.beta.8'
  spec.add_dependency 'virtus'
  spec.add_dependency 'rails', '>= 3.1'

  spec.add_development_dependency "rake", "~> 10.0"
end
