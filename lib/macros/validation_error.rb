# frozen_string_literal: true

module Macros
  # Custom error for validation failures
  # Raised when validation fails in service objects
  class ValidationError < StandardError
    attr_reader :errors

    # @param errors [Hash, ActiveModel::Errors, Array] validation errors
    def initialize(errors)
      @errors = normalize_errors(errors)
      super(error_message)
    end

    private

    def normalize_errors(errors)
      case errors
      when Hash
        errors
      when ActiveModel::Errors
        errors.to_hash
      when Array
        { base: errors }
      else
        { base: [errors.to_s] }
      end
    end

    def error_message
      if @errors.is_a?(Hash)
        messages = @errors.flat_map do |key, values|
          Array(values).map { |value| "#{key}: #{value}" }
        end
        "Validation failed: #{messages.join(', ')}"
      else
        "Validation failed: #{@errors}"
      end
    end
  end
end
