# frozen_string_literal: true
module Macros
  class Model
    # Import step for mass data import
    # @example
    #   step Macros::Model::Import(CommitBuild, key: 'commit_builds')
    class Import < Base
      # @param klass [Class] AR class that will be used to insert mass data into
      # @param key [String, Symbol] options key where the data that we want to import is
      # @param validate [Boolean] should we validate this data - since we expect to import
      #   data validated by contracts, by default it is off (no validations on models)
      def initialize(klass, key: 'model', validate: false)
        @key = key
        @klass = klass
        @validate = validate
      end

      # Performs a batch insert of data into table
      # @param [Trailblazer::Operation::Option] trbr options hash
      def call(options, **)
        resources = options[@key]

        attributes = resources.first&.attributes&.keys || []
        nullify = resources.first&.id.empty?
        attributes.delete('id') if nullify

        @klass.import(
          attributes,
          resources,
          validate: @validate,
          on_duplicate_key_ignore: true
        )
      end
    end
  end
end
