# frozen_string_literal: true
module Macros
  # Macros for available shared steps related to models
  class Model < Base
    register :build, proxy: true
    register :find, proxy: true
    register :import
    register :destroy
  end
end
