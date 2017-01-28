# frozen_string_literal: true
module Macros
  class Model
    # Persist step for removing object assigned in options['model']
    # @example
    #   step Macros::Model::Persist()
    class Persist < Base
      # @param method [Symbol] name of a method that we want to use to save model
      # @return [Macros::Model::Persist] persist step instance with appropriate options
      def initialize(method: :save!)
        @method = method
      end

      # Persists a given model
      # @param _options [Trailblazer::Operation::Option] options accumulator
      # @param model [Object] object that we want to persist
      def call(_options, model:, **)
        model.public_send(@method)
      end
    end
  end
end
