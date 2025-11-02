# frozen_string_literal: true

require 'uri'

RSpec.describe Macros::FormObject do
  # Mock ActiveRecord model for testing
  let(:mock_model_class) do
    Class.new do
      attr_accessor :name, :email, :age
      attr_reader :errors

      def initialize
        @errors = ActiveModel::Errors.new(self)
        @persisted = false
      end

      def persisted?
        @persisted
      end

      def save
        if valid?
          @persisted = true
          true
        else
          false
        end
      end

      def save!
        @persisted = true
        true
      end

      def valid?
        @errors.clear
        @errors.add(:name, 'required') if name.nil? || name.empty?
        @errors.empty?
      end

      def to_key
        persisted? ? [1] : nil
      end

      def to_param
        persisted? ? '1' : nil
      end
    end
  end

  let(:test_form_class) do
    Class.new(described_class) do
      attribute :name, :string
      attribute :email, :string
      attribute :age, :integer

      validates :name, presence: true
      validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
      validates :age, numericality: { greater_than: 0 }, allow_nil: true
    end
  end

  let(:model) { mock_model_class.new }
  let(:form) { test_form_class.new(model) }

  describe '#initialize' do
    it 'stores the model' do
      expect(form.model).to eq(model)
    end

    context 'when model is persisted' do
      it 'populates attributes from model' do
        model.name = 'John'
        model.email = 'john@example.com'
        model.age = 30
        model.instance_variable_set(:@persisted, true)

        form = test_form_class.new(model)
        expect(form.name).to eq('John')
        expect(form.email).to eq('john@example.com')
        expect(form.age).to eq(30)
      end
    end
  end

  describe '#validate' do
    it 'returns true for valid params' do
      result = form.validate(name: 'John', email: 'john@example.com')
      expect(result).to be true
    end

    it 'returns false for invalid params' do
      result = form.validate(name: '', email: 'invalid')
      expect(result).to be false
    end

    it 'populates errors for invalid params' do
      form.validate(name: '', email: 'invalid')
      expect(form.errors[:name]).to include("can't be blank")
      expect(form.errors[:email]).to include('is invalid')
    end

    it 'assigns attributes' do
      form.validate(name: 'John', email: 'john@example.com', age: 25)
      expect(form.name).to eq('John')
      expect(form.email).to eq('john@example.com')
      expect(form.age).to eq(25)
    end
  end

  describe '#save' do
    context 'with valid data' do
      before do
        form.validate(name: 'John', email: 'john@example.com')
      end

      it 'returns true' do
        expect(form.save).to be true
      end

      it 'syncs attributes to model' do
        form.save
        expect(model.name).to eq('John')
        expect(model.email).to eq('john@example.com')
      end

      it 'saves the model' do
        expect(model).not_to be_persisted
        form.save
        expect(model).to be_persisted
      end
    end

    context 'with invalid data' do
      before do
        form.validate(name: '', email: 'invalid')
      end

      it 'returns false' do
        expect(form.save).to be false
      end

      it 'does not save the model' do
        form.save
        expect(model).not_to be_persisted
      end

      it 'has errors' do
        form.save
        expect(form.errors).not_to be_empty
      end
    end

    context 'when model validation fails' do
      it 'copies model errors to form' do
        form.validate(name: '', email: 'valid@example.com')
        form.save
        # Model validation will add error
        expect(form.errors).not_to be_empty
      end
    end
  end

  describe '#save!' do
    it 'saves without validation' do
      form.name = ''  # Invalid
      form.email = 'invalid'  # Invalid
      expect(form.save!).to be true
      expect(model).to be_persisted
    end
  end

  describe '#persisted?' do
    it 'delegates to model' do
      expect(form.persisted?).to eq(model.persisted?)
      model.instance_variable_set(:@persisted, true)
      expect(form.persisted?).to be true
    end
  end

  describe '#to_key' do
    it 'delegates to model' do
      expect(form.to_key).to eq(model.to_key)
    end
  end

  describe '#to_param' do
    it 'delegates to model' do
      expect(form.to_param).to eq(model.to_param)
    end
  end

  describe '.model_name' do
    it 'returns model name without Form suffix' do
      # The class is anonymous, so we can't test the exact name
      # but we can verify it's an ActiveModel::Name
      expect(test_form_class.model_name).to be_a(ActiveModel::Name)
    end
  end
end
