# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'macros/version'

Gem::Specification.new do |spec|
  spec.name          = 'macros'
  spec.version       = ::Macros::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['Maciej Mensfeld']
  spec.email         = %w[maciej@mensfeld.pl]
  spec.homepage      = 'https://coditsu.com'
  spec.summary       = 'Trailblazer shared macros for Coditsu Quality Assurance tool'
  spec.description   = 'Trailblazer shared macros for Coditsu Quality Assurance tool'
  spec.license       = 'Trade secret'

  spec.add_dependency 'activesupport'
  spec.add_dependency 'require_all'
  spec.add_dependency 'trailblazer'
  spec.add_development_dependency 'bundler'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  spec.require_paths = %w[lib]
end
