# frozen_string_literal: true

module Macros
  # Contract related steps macros namespace
  class Contract
    # Step for contract validation
    # @example
    #   step Macros::Contract::Validate(key: :repository)
    class Validate < Base
      # Name of a default validation key
      DEFAULT_KEY = 'data'

      # Creates a contact validation step
      def call
        if args.last.is_a?(Hash)
          args.last[:key] ||= DEFAULT_KEY
        else
          args << { key: DEFAULT_KEY }
        end

        Trailblazer::Operation::Contract::Validate(*args)
      end
    end
  end
end
