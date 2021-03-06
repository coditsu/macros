# frozen_string_literal: true

module Macros
  class Error
    # Class for raise step
    # If we switched to the left track it will raise with some details for debugging
    # This should be used when we have mission critical flow that should always be right
    # @example Add as a last step so if anything fails - will raise
    #   failure Macros::Error::Raise()
    class Raise < Base
      # @param error_class [Class] error class that should be used to raise the error
      def initialize(error_class)
        @error_class = error_class
      end

      # @param ctx [Trailblazer::Operation::Result] operation result
      # @param args Any additional arguments that operation will pass
      # @raise [Exception] any exception that we've set to be raised in the initializer
      def call(ctx, *args)
        raise @error_class, [
          ctx['current_operation'],
          ctx['current_step'],
          args
        ]
      end
    end
  end
end
