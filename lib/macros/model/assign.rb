# frozen_string_literal: true
module Macros
  class Model
    # Assigns a given class to an options key for further usage
    # @example Assign Repository class as a model (for search, etc)
    #   step Macros::Model::Assign(Repository)
    class Assign < Macros::Base
      # @param klass [Class] class to assign to options given key
      # @param name [String, Symbol] key name under which the klass will be assigned
      # @return [Macros::Model::Assign] assign step instance
      def initialize(klass, name: 'model')
        @name = name
        @klass = klass
      end

      # Assings klass under appropriate options key
      # @param options [Trailblazer::Operation::Option] trbr options hash
      def call(options, **)
        options[@name] = @klass
      end
    end
  end
end
