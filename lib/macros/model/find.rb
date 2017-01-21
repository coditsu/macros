# frozen_string_literal: true
module Macros
  class Model
    # Find step for finding object from a scope / class - it will use params[:id] as a key
    # @example
    #   step Macros::Model::Find(Repository)
    class Find < Base
      # @param scope [Class, ActiveRecord::Relation] class or scope on which we will search
      def initialize(scope, action = :find_by)
        self.args = [scope, action]
      end

      # Builds a step
      def call
        Trailblazer::Operation::Model(*args)
      end
    end
  end
end
