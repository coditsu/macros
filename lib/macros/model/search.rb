# frozen_string_literal: true
module Macros
  class Model
    class Search < Macros::Base
      def initialize(name: 'model', validate: false)
        @name = name
        @validate = validate
      end

      def call(options, **)
        scope = options[@name]
        options["#{@name}_search"] = scope.search(options['current_search'])
        options[@name] = options["#{@name}_search"].result
      end
    end
  end
end
