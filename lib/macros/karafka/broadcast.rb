# frozen_string_literal: true

module Macros
  class Karafka
    # Broadcasts a given field with a given responder
    class Broadcast < Base
      # @param responder_class [Class] class name of a responder we want to use
      # @param name [String, Symbol] key name of resource in trbr options hash that
      #   we want to broadcast
      def initialize(responder_class, name: 'model')
        @responder_class = responder_class
        @name = name
      end

      # Runs responder to respond to Kafka with a set of messages
      # @param options [Trailblazer::Operation::Option] trbr options hash
      def call(options, **)
        @responder_class.call(options[@name])
      end
    end
  end
end
