# frozen_string_literal: true
module Macros
  class Model
    # Find step for finding object from a scope / class - it will use params[:id] as a key
    # @example
    #   step Macros::Model::Find(Repository)
    class Find < Base
      def initialize(scope, action = :find_by!)
        @scope = scope
        @action = action
      end

      # Builds a step
      def call(options, *args)
        Macros::Model::Query.new(@scope, @action).call(options, *args)
      end
    end
  end
end
