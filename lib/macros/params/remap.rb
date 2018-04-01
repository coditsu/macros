# frozen_string_literal: true

module Macros
  class Params
    # Remap step for remapping params in operations
    class Remap < Base
      # @param from [Symbol] name of key we want to remap
      # @param to [Symbol] name of key to where we want to map
      # @return [Macros::Params::Remap] remapper step instance
      def initialize(from:, to:)
        @from = Array(from)
        @to = to
      end

      # @param ctx [Trailblazer::Skill] context accumulator
      # @param params [Hash] hash with params for remapping
      # @note We don't remove the original key as we anyhow sanitize stuff with contracts
      #  so it is not worth and original field can be used in other places
      def call(ctx, params:, **)
        params[@to] = params.dig(*@from)
      end
    end
  end
end
