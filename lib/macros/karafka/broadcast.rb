# frozen_string_literal: true

module Macros
  class Karafka
    # Broadcasts a given field with a given responder
    class Broadcast < Base
      # @param responder_class [Class] class name of a responder we want to use
      # @param name [String, Symbol] key name of resource in trbr context hash that
      #   we want to broadcast
      def initialize(responder_class, name: 'model')
        @responder_class = responder_class
        @name = name
      end

      # Runs responder to respond to Kafka with a set of messages
      # @param ctx [Trailblazer::Skill] trbr context hash
      def call(ctx, **)
        @responder_class.call(ctx[@name])
      end
    end
  end
end
