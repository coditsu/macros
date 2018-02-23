# frozen_string_literal: true

module Macros
  class Params
    # Remap step for remapping params in operations
    class Remap < Base
      # @param remapper_class [Class] remapper class that we want to use to remap parameters
      # @return [Macros::Params::Remap] remapper step instance
      def initialize(remapper_class)
        @remapper_class = remapper_class
      end

      # Uses default mapper to remap params
      # @param ctx [Trailblazer::Skill] context accumulator
      # @param params [Hash] hash with params for remapping
      def call(ctx, params:, **)
        ctx['params'] = @remapper_class.call(params)
      end
    end
  end
end
