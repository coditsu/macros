# frozen_string_literal: true

module Macros
  class Model
    # Searches based on current_search data and overwrites our model/resource
    # @see https://github.com/activerecord-hackery/ransack for more current_search details
    # @example
    #   step Macros::Option::Assign(Repository::Author)
    #   step Macros::Model::Search()
    #   ctx['model_search'] #=> Ransack search object
    #   ctx['model'] #=> Repository authors that match search
    class Search < Macros::Base
      # @param name [String] name under which we will assign search results (also source for base
      #   search class)
      # @param default_sort_order [String, Array<String>] default orders that we can apply when
      #   there is no user sorting
      # @return [Macros::Model::Search] search macro step
      def initialize(name: 'model', default_sort_order: nil)
        @name = name
        # We cast it to array conditionally (if not array) to cover both cases
        # for default_sort_order as a string and as an array of strings
        @default_sort_order = Array(default_sort_order)
      end

      # Performs this macro
      # @param ctx [Trailblazer::Skill] trbr context hash
      # @param current_search [Hash] hash with ransack search details
      def call(ctx, current_search:, **)
        search = ctx[@name].search(current_search)
        search.sorts = @default_sort_order if search.sorts.empty?

        ctx["#{@name}_search"] = search
        ctx[@name] = search.result
      end
    end
  end
end
