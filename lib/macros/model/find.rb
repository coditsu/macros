# frozen_string_literal: true

module Macros
  class Model
    # Searches on a given scope and assigns result to a ctx hash
    #
    # @example Simple find using #find and 'model' ctx key
    #   step Macros::Model::Find(Repository)
    #
    # @example Find that searches on Repository and assigns under alternative name
    #   step Macros::Model::Find(Repository, name: 'repository')
    class Find < Base
      # Creates a macro instance with appropriate ctx
      # @param scope [Class, ActiveRecord::Relation] class or AR relation on which we search
      # @param action [Symbol] action/method  name that we want to use to perform search on scope
      # @param name [String] name under which we will assign results in the ctx hash
      # @param search_attribute [Symbol] attribute name that will be searched on
      # @return [Macros::Model::Find] find macro instance
      #
      # @example Commit search on repository_id
      #   new(Commit, search_attribute: :repository_id, params_key: :repository_id)
      def initialize(scope, action = :find, name: 'model', search_attribute: :id, params_key: :id)
        @name = name
        @scope = scope
        @action = action
        @params_key = params_key
        @search_attribute = search_attribute
      end

      # Performs a search find given ctx
      # @param ctx [Trailblazer::Skill] trbr context hash
      # @param params [Hash] hash with input parameters
      def call(ctx, params:, **)
        # :find works differently that any other AR search as it does not take attr name
        ctx[@name] = if @action == :find
                       @scope.public_send(
                         @action,
                         params.fetch(@params_key)
                       )
                     else
                       @scope.public_send(
                         @action,
                         @search_attribute => params[@params_key]
                       )
                     end
      end
    end
  end
end
