# frozen_string_literal: true
module Macros
  class Model
    # Persist step for removing object assigned in options['model']
    # @example
    #   step Macros::Model::Persist()
    class Persist < Base
      # @param name [String] options key name under which is object that we want to persist
      # @param method [Symbol] name of a method that we want to use to save model
      # @return [Macros::Model::Persist] persist step instance with appropriate options
      def initialize(name: 'model', method: :save!)
        @name = name
        @method = method
      end

      # Persists a given model
      # @param options [Trailblazer::Operation::Option] options accumulator
      # @param model [Object] object that we want to persist
      def call(options, model:, **)
        options[@name].public_send(@method)
      end
    end
  end
end
