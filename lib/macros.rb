# frozen_string_literal: true
%w(
  trailblazer
  require_all
  active_support/inflector
).each { |lib| require lib }

module Macros
  class << self
    # @return [String] root path to this gem
    # @example
    #   Macros.gem_root #=> '/home/user/.gems/macros'
    def gem_root
      File.expand_path('../..', __FILE__)
    end
  end
end

require_all File.dirname(__FILE__) + '/**/*.rb'
