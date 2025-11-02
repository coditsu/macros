# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'macros/version'

Gem::Specification.new do |spec|
  spec.name          = 'macros'
  spec.version       = Macros::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['Maciej Mensfeld']
  spec.email         = %w[contact@coditsu.io]
  spec.homepage      = 'https://coditsu.io'
  spec.summary       = 'Service object framework for Coditsu Quality Assurance tool'
  spec.description   = 'Lightweight service object framework with form objects (Trailblazer-free)'
  spec.license       = 'LGPL-3.0'

  spec.add_dependency 'activesupport'
  spec.add_dependency 'activemodel'
  spec.add_dependency 'require_all'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  spec.require_paths = %w[lib]
  spec.metadata['rubygems_mfa_required'] = 'true'
end
