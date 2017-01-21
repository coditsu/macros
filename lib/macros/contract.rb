# frozen_string_literal: true
# Namespace for macros steps
module Macros
  # Macros for available shared steps related to contracts
  class Contract < Base
    register :build, proxy: true
    register :validate, proxy: true
    register :persist, proxy: true
  end
end
