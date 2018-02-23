# frozen_string_literal: true

module Macros
  class Model
    # Destroy step for removing object assigned in ctx['model']
    # @example
    #   step Macros::Model::Destroy()
    class Destroy < Base
      # Destroys a given model
      # @param _ctx [Trailblazer::Skill] context accumulator
      # @param model [Object] object that we want to destroy
      def call(_ctx, model:, **)
        model.destroy
      end
    end
  end
end
