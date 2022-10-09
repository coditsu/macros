# frozen_string_literal: true

module Macros
  # Base class for all the Trbr step macros
  class Base
    include Uber::Callable

    # @param args [Hash] Any arguments that our macro operation supports
    #
    # @return Single step object that can be used in operation step
    def initialize(args = {})
      self.args = args
    end

    private

    attr_accessor :args
  end
end
