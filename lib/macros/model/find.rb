# frozen_string_literal: true
module Macros
  class Model
    class Find < Base
      def initialize(scope, action = :find, name: 'model', search_key: :id, params_key: :id)
        @scope = scope
        @action = action
        @name = name
        @params_key = params_key
        @search_key = search_key
      end

      def call(options, params:, **)
        args = @action == :find ? params[@params_key] : { @search_key => params[@params_key] }
        options[@name] = @scope.public_send(@action, args)
      end
    end
  end
end
