# frozen_string_literal: true

module Macros
  class Model
    # Extracts from a given object from an options hash a given attribute/method and assigns
    # it under diferrent key
    # @example Find validation object and fetch repository out of it
    #   step Macros::Model::Find(Validation, name: 'validation', params_key: :validation_id)
    #   step Macros::Model::Fetch(:repository, from: 'validation')
    #   options['repository'] #=> Repository instance
    class Fetch < Macros::Base
      # @param resource_name [Symbol] name of element/resource that we want to extract and
      #   method that we want to use to exract it at the same time
      # @param from [String] options key under which the base model for fetching is
      # @param to [String, nil] options key under the target fetched element should be saved
      #   If not provided, will assign under the same name as resource_name
      # @return [Macros::Model::Fetch] step macro instance
      def initialize(resource_name, from: 'model', to: nil)
        @resource_name = resource_name
        @from = from
        @to = to || resource_name.to_s
      end

      # Executes this macro
      # @param options [Trailblazer::Operation::Option] trbr options hash
      def call(options, **)
        options[@to.to_s] = options[@from].public_send(@resource_name)
      end
    end
  end
end
