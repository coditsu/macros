# frozen_string_literal: true

%w[
  delegate
  require_all
  active_support/inflector
  active_model
].each { |lib| require lib }

# Service object framework for Coditsu applications
# Version 2.0 - No longer depends on Trailblazer
module Macros
  class << self
    # @return [String] root path to this gem
    # @example
    #   Macros.gem_root #=> '/home/user/.gems/macros'
    def gem_root
      File.expand_path('..', __dir__)
    end
  end
end

# Require new base classes first
require_relative 'macros/result'
require_relative 'macros/validation_error'
require_relative 'macros/service_object'
require_relative 'macros/form_object'
require_relative 'macros/version'

# Old Trailblazer-based macros are kept for backward compatibility during migration
# They are only loaded if Trailblazer is available
# These will be deprecated and removed in version 3.0
begin
  require 'trailblazer'
  require 'uber/options'

  # Only load old macros if Trailblazer is available
  require_relative 'macros/base'
  require_all "#{File.dirname(__FILE__)}/**/*/", pattern: '*.rb'

  # Mark that old macros are available
  @legacy_macros_loaded = true
rescue LoadError
  # Trailblazer not available - skip old macros
  # This is expected in v2.0 when using new service object pattern
  @legacy_macros_loaded = false
end

def self.legacy_macros_loaded?
  @legacy_macros_loaded || false
end
