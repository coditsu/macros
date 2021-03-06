# frozen_string_literal: true

module Macros
  class Contract
    # @example Step for setting contract class and building a new contract
    #   contract Contracts::MyContract
    #   step Macros::Contract::Build()
    class Build < Base
      # Builds a contract step
      def call
        Trailblazer::Operation::Contract::Build(*args)
      end
    end
  end
end
