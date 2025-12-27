# frozen_string_literal: true

module Macros
  # Service object pattern module
  # Include this module to create service objects that replace Trailblazer operations
  #
  # @example Basic usage
  #   class MyService
  #     include Macros::ServiceObject
  #
  #     def run
  #       # Your business logic here
  #       success(user: @user)
  #     end
  #   end
  #
  #   result = MyService.call(params: params, context: context)
  #   if result.success?
  #     result[:user]
  #   else
  #     result.errors
  #   end
  module ServiceObject
    # Hook called when module is included
    # @param base [Class] the class including this module
    def self.included(base)
      base.extend ClassMethods
      base.include InstanceMethods
    end

    # Class methods added to service objects
    module ClassMethods
      # Call the service object
      # @param params [Hash] parameters for the service
      # @param context [Hash] context data (current_user, etc.)
      # @return [Result] result object
      def call(params: {}, context: {})
        new.call(params: params, context: context)
      end
    end

    # Instance methods added to service objects
    module InstanceMethods
      # Main entry point for service objects
      # @param params [Hash] parameters for the service
      # @param context [Hash] context data (current_user, etc.)
      # @return [Result] result object
      def call(params: {}, context: {})
        @params = params
        @context = context
        @result = Result.new

        run
      rescue ValidationError => e
        failure(e.errors)
      rescue StandardError => e
        handle_error(e)
      end

      private

      attr_reader :params, :context, :result

      # Mark operation as successful
      # @param data [Hash] success data
      # @return [Result] result object
      def success(data = {})
        @result.success!(data)
        @result
      end

      # Mark operation as failed
      # @param errors [Hash] error data
      # @return [Result] result object
      def failure(errors = {})
        @result.failure!(errors)
        @result
      end

      # Override this method to implement business logic
      # @return [Result] result object
      # @raise [NotImplementedError] if not overridden
      def run
        raise NotImplementedError, "#{self.class} must implement #run"
      end

      # Handle unexpected errors
      # Override this method to customize error handling
      # @param error [StandardError] the error to handle
      # @return [Result] result object with error
      def handle_error(error)
        # Re-raise in test environments
        raise error if !defined?(Rails) || Rails.env.test? || Rails.env.development?

        # Log error in production
        if defined?(Rails)
          Rails.logger.error("Service object error: #{error.class} - #{error.message}")
          Rails.logger.error(error.backtrace.join("\n"))
        end
        failure(errors: { base: ['An unexpected error occurred'] })
      end
    end
  end
end
