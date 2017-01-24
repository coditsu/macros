# frozen_string_literal: true
module Macros
  # Macros for available shared steps related to models
  class Model < Base
    register :build, proxy: true
    register :find
    register :import
    register :query
    register :destroy
  end
end
