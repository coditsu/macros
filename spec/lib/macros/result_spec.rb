# frozen_string_literal: true

RSpec.describe Macros::Result do
  subject(:result) { described_class.new }

  describe '#initialize' do
    it 'starts as failure' do
      expect(result).not_to be_success
      expect(result).to be_failure
    end

    it 'has empty data' do
      expect(result.data).to eq({})
    end

    it 'has empty errors' do
      expect(result.errors).to eq({})
    end
  end

  describe '#success!' do
    it 'marks result as successful' do
      result.success!(user: 'test')
      expect(result).to be_success
      expect(result).not_to be_failure
    end

    it 'stores data' do
      result.success!(user: 'test', id: 123)
      expect(result.data).to eq(user: 'test', id: 123)
    end

    it 'allows empty data' do
      result.success!
      expect(result).to be_success
      expect(result.data).to eq({})
    end

    it 'returns self' do
      expect(result.success!).to eq(result)
    end
  end

  describe '#failure!' do
    it 'marks result as failed' do
      result.failure!(error: 'test')
      expect(result).to be_failure
      expect(result).not_to be_success
    end

    it 'stores errors as hash' do
      result.failure!(name: ['required'], email: ['invalid'])
      expect(result.errors).to eq(name: ['required'], email: ['invalid'])
    end

    it 'allows empty errors' do
      result.failure!
      expect(result).to be_failure
      expect(result.errors).to eq({})
    end

    it 'returns self' do
      expect(result.failure!).to eq(result)
    end
  end

  describe '#[]' do
    it 'accesses data by key' do
      result.success!(user: 'test', id: 123)
      expect(result[:user]).to eq('test')
      expect(result[:id]).to eq(123)
    end

    it 'returns nil for missing keys' do
      result.success!(user: 'test')
      expect(result[:missing]).to be_nil
    end
  end

  describe '#[]=' do
    it 'sets data by key' do
      result[:user] = 'test'
      expect(result[:user]).to eq('test')
    end
  end

  describe '#to_h' do
    context 'when success' do
      it 'returns data' do
        result.success!(user: 'test')
        expect(result.to_h).to eq(user: 'test')
      end
    end

    context 'when failure' do
      it 'returns errors wrapped' do
        result.failure!(name: ['required'])
        expect(result.to_h).to eq(errors: { name: ['required'] })
      end
    end
  end
end
