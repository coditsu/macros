# frozen_string_literal: true

module Macros
  class Model
    # Persist step for removing object assigned in ctx['model']
    # @example
    #   step Macros::Model::Persist()
    class Persist < Base
      # @param method [Symbol] name of a method that we want to use to save model
      # @return [Macros::Model::Persist] persist step instance with appropriate ctx
      def initialize(method: :save!)
        @method = method
      end

      # Persists a given model
      # @param _ctx [Trailblazer::Skill] context accumulator
      # @param model [Object] object that we want to persist
      def call(_ctx, model:, **)
        model.public_send(@method)
      end
    end
  end
end
