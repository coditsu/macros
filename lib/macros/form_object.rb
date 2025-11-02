# frozen_string_literal: true

module Macros
  # Form object base class
  # Replaces Reform forms with ActiveModel-based forms
  #
  # @example Basic usage
  #   class UserForm < Macros::FormObject
  #     attribute :name, :string
  #     attribute :email, :string
  #
  #     validates :name, presence: true
  #     validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  #   end
  #
  #   user = User.new
  #   form = UserForm.new(user)
  #   if form.validate(params[:user])
  #     form.save
  #   else
  #     form.errors
  #   end
  class FormObject
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations

    attr_reader :model

    # Initialize form with a model
    # @param model [ActiveRecord::Base] the model to wrap
    def initialize(model)
      @model = model
      super() # Initialize ActiveModel::Attributes
      populate_from_model if model.persisted?
    end

    # Validate form with given parameters
    # @param params [Hash] parameters to validate
    # @return [Boolean] true if valid, false otherwise
    def validate(params)
      assign_attributes(params)
      valid?
    end

    # Save the form (validates and persists to model)
    # @return [Boolean] true if saved successfully
    def save
      return false unless valid?

      # Sync attributes to model
      sync_to_model

      # Save the model
      if model.save
        true
      else
        # Copy model errors to form errors
        copy_model_errors
        false
      end
    end

    # Save without validation (dangerous!)
    # @return [Boolean] true if saved successfully
    def save!
      sync_to_model
      model.save!
      true
    end

    # Get all errors (form + model)
    # @return [ActiveModel::Errors] combined errors
    def errors
      # Combine form validation errors with model errors
      @errors ||= super
      copy_model_errors if model.errors.any?
      @errors
    end

    # Check if form is persisted (delegates to model)
    # @return [Boolean]
    def persisted?
      model.persisted?
    end

    # Get model name (delegates to model class)
    # Allows form objects to work with form helpers
    # @return [ActiveModel::Name]
    def self.model_name
      # Handle anonymous classes (used in tests)
      form_name = name || 'AnonymousForm'
      model_name = form_name.split('::').last.gsub(/Form$/, '')
      ActiveModel::Name.new(self, nil, model_name)
    end

    # Get record ID (delegates to model)
    # @return [Object] model's ID
    def to_key
      model.to_key
    end

    # Get record param (delegates to model)
    # @return [String] model's param
    def to_param
      model.to_param
    end

    private

    # Populate form attributes from model
    def populate_from_model
      self.class.attribute_names.each do |attr|
        next unless model.respond_to?(attr)
        next if attr == 'model'

        public_send("#{attr}=", model.public_send(attr))
      end
    end

    # Sync form attributes to model
    def sync_to_model
      self.class.attribute_names.each do |attr|
        next unless model.respond_to?("#{attr}=")
        next if attr == 'model'

        model.public_send("#{attr}=", public_send(attr))
      end
    end

    # Copy model validation errors to form errors
    def copy_model_errors
      model.errors.each do |error|
        @errors.add(error.attribute, error.message) unless @errors.added?(error.attribute, error.message)
      end
    end
  end
end
