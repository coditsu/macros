# frozen_string_literal: true

RSpec.describe Macros::ServiceObject do
  let(:test_service) do
    Class.new do
      include Macros::ServiceObject

      def run
        if params[:fail]
          failure(base: ['Test error'])
        else
          success(result: 'test', data: params[:data])
        end
      end
    end
  end

  let(:failing_service) do
    Class.new do
      include Macros::ServiceObject

      def run
        raise Macros::ValidationError.new(name: ['required'])
      end
    end
  end

  let(:error_service) do
    Class.new do
      include Macros::ServiceObject

      def run
        raise StandardError, 'Unexpected error'
      end
    end
  end

  describe '.call' do
    it 'creates instance and calls it' do
      result = test_service.call(params: { data: 'test' }, context: {})
      expect(result).to be_a(Macros::Result)
      expect(result).to be_success
    end

    it 'passes params and context' do
      result = test_service.call(params: { data: 'value' }, context: { user: 'test' })
      expect(result[:data]).to eq('value')
    end
  end

  describe '#call' do
    subject(:service) { test_service.new }

    it 'returns success result' do
      result = service.call(params: {}, context: {})
      expect(result).to be_success
      expect(result[:result]).to eq('test')
    end

    it 'returns failure result' do
      result = service.call(params: { fail: true }, context: {})
      expect(result).to be_failure
      expect(result.errors).to eq(base: ['Test error'])
    end

    it 'catches ValidationError' do
      result = failing_service.call(params: {}, context: {})
      expect(result).to be_failure
      expect(result.errors).to eq(name: ['required'])
    end

    it 'handles unexpected errors in test environment' do
      expect {
        error_service.call(params: {}, context: {})
      }.to raise_error(StandardError, 'Unexpected error')
    end
  end

  describe '#run' do
    it 'must be implemented by subclass' do
      base_service = Class.new do
        include Macros::ServiceObject
      end

      expect {
        base_service.call(params: {}, context: {})
      }.to raise_error(NotImplementedError, /must implement #run/)
    end
  end

  describe 'success and failure helpers' do
    let(:custom_service) do
      Class.new do
        include Macros::ServiceObject

        def run
          if params[:succeed]
            success(user: 'john', id: 123)
          else
            failure(name: ['required'])
          end
        end
      end
    end

    it 'success helper returns successful result' do
      result = custom_service.call(params: { succeed: true }, context: {})
      expect(result).to be_success
      expect(result[:user]).to eq('john')
      expect(result[:id]).to eq(123)
    end

    it 'failure helper returns failed result' do
      result = custom_service.call(params: {}, context: {})
      expect(result).to be_failure
      expect(result.errors).to eq(name: ['required'])
    end
  end
end
