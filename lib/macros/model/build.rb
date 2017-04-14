# frozen_string_literal: true

module Macros
  class Model
    # Build step for creating new objects from a class/scope
    class Build < Base
      # @param scope [Class, ActiveRecord::Relation] class for which we want to create a new
      #   instance or a scope if we build from a scope
      # @example
      #   step Macros::Model::Build(Repository)
      def initialize(scope)
        self.args = [scope, :new]
      end

      # Passes data to a Trailblazer::Operation::Model
      def call
        Trailblazer::Operation::Model(*args)
      end
    end
  end
end
