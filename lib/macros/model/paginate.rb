# frozen_string_literal: true
module Macros
  class Model
    # Runs a pagination for a model and reassigns it under the same name
    #
    # @note It requires a current_page to be injected. It expect it to be a page number
    #
    # @example Assign authors as a model and paginate them
    #   step Macros::Option::Assign(Repository::Author)
    #   step Macros::Model::Paginate()
    class Paginate < Macros::Base
      # @param name [String] options key name under which is a collection that we want to paginate
      # @return [Macros::Model::Paginate] paginate macro step
      def initialize(name: 'model')
        @name = name
      end

      # Performs pagination
      # @param options [Trailblazer::Operation::Option] trbr options hash
      # @param current_page [Integer] number of current page that we want to see
      def call(options, current_page:, **)
        options[@name] = options[@name].page(current_page)
      end
    end
  end
end
