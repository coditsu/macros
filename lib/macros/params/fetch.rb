# frozen_string_literal: true

module Macros
  class Params
    # Fetches a given param key into the options hash for further usage
    class Fetch < Base
      # @param from [String, Symbol] params key under which our requested element is present
      # @param to [Strinig, Symbol] options key where we want to fetch our params value
      def initialize(from:, to: nil)
        @from = Array(from)
        @to = to || @from.last
      end

      # Fetches a given params key into options
      # @param options [Trailblazer::Operation::Option] options accumulator
      # @param params [Hash] hash with params
      def call(options, params:, **)
        options[@to] = params.dig(*@from)
      end
    end
  end
end