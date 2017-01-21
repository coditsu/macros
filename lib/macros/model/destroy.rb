# frozen_string_literal: true
module Macros
  class Model
    # Destroy step for removing object assigned in options['model']
    # @example
    #   step Macros::Model::Destroy()
    class Destroy < Base
      # Destroys a given model
      # @param _options [Trailblazer::Operation::Option] options accumulator
      # @param model [Object] object that we want to destroy
      def call(_options, model:, **)
        model.destroy
      end
    end
  end
end
