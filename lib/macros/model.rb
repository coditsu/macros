# frozen_string_literal: true
module Macros
  # Macros for available shared steps related to models
  class Model < Base
    register :assign
    register :build, proxy: true
    register :destroy
    register :fetch
    register :find
    register :import
    register :persist
    register :search
  end
end
