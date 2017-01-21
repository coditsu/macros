# frozen_string_literal: true
module Macros
  class Contract
    # Step for contract persistance
    # @example
    #   step Macros::Contract::Persist()
    class Persist < Base
      # Build and return persistance contract step
      def call
        Trailblazer::Operation::Contract::Persist(*args)
      end
    end
  end
end
