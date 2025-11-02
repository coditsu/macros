# frozen_string_literal: true

module Macros
  # Result object for service objects
  # Represents the outcome of a service object call
  class Result
    attr_reader :data, :errors

    def initialize
      @success = false
      @data = {}
      @errors = {}
    end

    # Mark result as successful with optional data
    # @param data [Hash] success data to store
    # @return [Result] self
    def success!(data = {})
      @success = true
      @data = data
      self
    end

    # Mark result as failed with optional errors
    # @param errors [Hash, ActiveModel::Errors, Array] errors to store
    # @return [Result] self
    def failure!(errors = {})
      @success = false
      @errors = normalize_errors(errors)
      self
    end

    # Check if result is successful
    # @return [Boolean]
    def success?
      @success
    end

    # Check if result is a failure
    # @return [Boolean]
    def failure?
      !@success
    end

    # Access data by key
    # @param key [Symbol, String] key to access
    # @return [Object] value at key
    def [](key)
      @data[key]
    end

    # Set data by key
    # @param key [Symbol, String] key to set
    # @param value [Object] value to set
    def []=(key, value)
      @data[key] = value
    end

    # Convert result to hash
    # @return [Hash]
    def to_h
      success? ? data : { errors: errors }
    end

    private

    # Normalize different error formats to a hash
    # @param errors [Hash, ActiveModel::Errors, Array, Object] errors to normalize
    # @return [Hash] normalized errors hash
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
  end
end
