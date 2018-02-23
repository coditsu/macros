# frozen_string_literal: true

module Macros
  # Macros for manipulating ctx
  class Ctx
    # Assigns a given class to an ctx key for further usage
    # @example Assign Repository class as a model (for search, etc)
    #   step Macros::Ctx::Assign(Repository)
    class Assign < Macros::Base
      # @param klass [Class] class to assign to ctx given key
      # @param name [String, Symbol] key name under which the klass will be assigned
      # @return [Macros::Ctx::Assign] assign step instance
      def initialize(klass, name: 'model')
        @name = name
        @klass = klass
      end

      # Assings klass under appropriate ctx key
      # @param ctx [Trailblazer::Skill] trbr context hash
      def call(ctx, **)
        ctx[@name] = @klass
      end
    end
  end
end
