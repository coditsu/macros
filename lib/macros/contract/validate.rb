# frozen_string_literal: true
module Macros
  # Contract related steps macros namespace
  class Contract
    # Step for contract validation
    # @example
    #   step Macros::Contract::Validate(key: :repository)
    class Validate < Base
      # Creates a contact validation step
      def call
        Trailblazer::Operation::Contract::Validate(*args)
      end
    end
  end
end
