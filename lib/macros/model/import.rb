# frozen_string_literal: true

module Macros
  class Model
    # Import step for mass data import
    # @example
    #   step Macros::Model::Import(CommitBuild, key: 'commit_builds')
    class Import < Base
      # @param klass [Class] AR class that will be used to insert mass data into
      # @param key [String, Symbol] options key where the data that we want to import is
      # @param on_duplicate_key_ignore [Boolean] should we just ignore if duplicate or update
      # @param batch_size [Integer] batch size per each insert
      # @param except [Array] array with names of keys we want to ignore when inserting
      # @return [Macros::Model::Import] import step with appropriate options
      def initialize(
        klass,
        key: 'model',
        on_duplicate_key_ignore: true,
        on_duplicate_key_update: nil,
        batch_size: nil,
        except: []
      )
        @key = key
        @klass = klass
        @validate = false
        @on_duplicate_key_ignore = on_duplicate_key_ignore
        @on_duplicate_key_update = on_duplicate_key_update
        @batch_size = batch_size
        @except = except
      end

      # Performs a batch insert of data into table
      # @param options [Trailblazer::Operation::Option] trbr options hash
      def call(options, **)
        # Wrapping with array allows us to import also single resources
        resources = Array(options[@key])

        attributes = (resources.first&.attributes&.keys || [])
        nullify = resources.first&.id.to_s.empty?
        attributes.delete('id') if nullify

        # We normalize attributes to strings to support hashes and structs
        @klass.import(
          attributes.map(&:to_s) - @except.map(&:to_s),
          resources,
          validate: @validate,
          on_duplicate_key_ignore: @on_duplicate_key_ignore,
          on_duplicate_key_update: @on_duplicate_key_update,
          batch_size: @batch_size
        )
      end
    end
  end
end
