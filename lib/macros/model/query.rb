# frozen_string_literal: true
module Macros
  class Model
    class Query < Base
      def initialize(scope, action = :find_by!, name: 'model', search_key: :id, params_key: :id)
        @scope = scope
        @action = action
        @name = name
        @params_key = params_key
        @search_key = search_key
      end

      def call(options, params:, **)
        options[@name] = @scope.public_send(@action, @search_key => params[@params_key])
      end
    end
  end
end
