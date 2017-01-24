# frozen_string_literal: true
module Macros
  class Model
    class Find < Base
      def initialize(scope, action = :find)
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
