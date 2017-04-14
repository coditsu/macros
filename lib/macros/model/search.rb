# frozen_string_literal: true

module Macros
  class Model
    # Searches based on current_search data and overwrites our model/resource
    # @see https://github.com/activerecord-hackery/ransack for more current_search details
    # @example
    #   step Macros::Option::Assign(Repository::Author)
    #   step Macros::Model::Search()
    #   options['model_search'] #=> Ransack search object
    #   options['model'] #=> Repository authors that match search
    class Search < Macros::Base
      # @param name [String] name under which we will assign search results (also source for base
      #   search class)
      # @return [Macros::Model::Search] search macro step
      def initialize(name: 'model')
        @name = name
      end

      # Performs this macro
      # @param options [Trailblazer::Operation::Option] trbr options hash
      # @param current_search [Hash] hash with ransack search details
      def call(options, current_search:, **)
        options["#{@name}_search"] = options[@name].search(current_search)
        options[@name] = options["#{@name}_search"].result
      end
    end
  end
end
