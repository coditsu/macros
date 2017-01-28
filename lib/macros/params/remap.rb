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
      # @param options [Trailblazer::Operation::Option] options accumulator
      # @param params [Hash] hash with params for remapping
      def call(options, params:, **)
        options['params'] = @remapper_class.call(params)
      end
    end
  end
end
