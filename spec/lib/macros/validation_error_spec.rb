# frozen_string_literal: true

RSpec.describe Macros::ValidationError do
  describe '#initialize' do
    it 'stores hash errors' do
      error = described_class.new(name: ['required'], email: ['invalid'])
      expect(error.errors).to eq(name: ['required'], email: ['invalid'])
    end

    it 'stores array errors' do
      error = described_class.new(%w[error1 error2])
      expect(error.errors).to eq(base: %w[error1 error2])
    end

    it 'converts string to hash' do
      error = described_class.new('simple error')
      expect(error.errors).to eq(base: ['simple error'])
    end

    it 'has descriptive message' do
      error = described_class.new(name: ['required'])
      expect(error.message).to include('Validation failed')
      expect(error.message).to include('name')
      expect(error.message).to include('required')
    end
  end
end
