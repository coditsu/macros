# frozen_string_literal: true

module Macros
  class Model
    # Assigns a given attribute to a resource that is under a to key
    # This can be used to setup models
    # @example Find repository and assign it to a new commit build
    #   step Macros::Model::Find(Repository, name: 'repository', params_key: :repository_id)
    #   step Macros::Model::Build(CommitBuild)
    #   step Macros::Model::Assign(:repository)
    class Assign < Macros::Base
      # @return [Macros::Model::Assign] step macro instance
      # @param name [Symbol] resource name that we want to assign
      # @param to [String] options key under which is a resource to which we want to assign
      def initialize(name, to: 'model')
        @name = name
        @to = to
      end

      # Performs a step by assigning as an attribute a value from options hash
      # @param options [Trailblazer::Operation::Option] trbr options hash
      def call(options, **)
        options[@to.to_s].public_send(:"#{@name}=", options[@name.to_s])
      end
    end
  end
end
