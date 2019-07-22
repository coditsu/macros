# frozen_string_literal: true

RSpec.describe_current do
  let(:ctx) { {} }
  let(:found_instance) { scope.new }
  let(:search_value) { rand }

  let(:scope) do
    Class.new do
      def self.find(*_args); end

      def self.find_by(*_args); end

      self
    end
  end

  context 'when it is a default case' do
    subject(:query_step) { described_class.new(scope) }

    let(:params) { { params: { id: search_value } } }

    it 'expect to use default for querying and assignment' do
      expect(scope).to receive(:find).with(search_value).and_return(found_instance)
      query_step.call(ctx, params)
      expect(ctx['model']).to eq found_instance
    end
  end

  context 'when custom name assignment usage' do
    subject(:query_step) { described_class.new(scope, name: name) }

    let(:name) { rand }
    let(:params) { { params: { id: search_value } } }

    it 'expect to assign under custom name' do
      expect(scope).to receive(:find).with(search_value).and_return(found_instance)
      query_step.call(ctx, params)
      expect(ctx[name]).to eq found_instance
    end
  end

  context 'when custom action' do
    subject(:query_step) { described_class.new(scope, action) }

    let(:action) { :find_by }
    let(:params) { { params: { id: search_value } } }

    it 'expect to use custom query method' do
      expect(scope).to receive(:find_by).with(id: search_value).and_return(found_instance)
      query_step.call(ctx, params)
      expect(ctx['model']).to eq found_instance
    end
  end

  context 'when custom search key' do
    subject(:query_step) { described_class.new(scope, search_attribute: search_attribute) }

    let(:search_attribute) { rand }
    let(:params) { { params: { id: search_value } } }

    it 'expect to use custom search key' do
      expect(scope).to receive(:find).with(search_value).and_return(found_instance)
      query_step.call(ctx, params)
      expect(ctx['model']).to eq found_instance
    end
  end

  context 'when custom params key' do
    subject(:query_step) { described_class.new(scope, params_key: params_key) }

    let(:params_key) { rand }
    let(:params) { { params: { params_key => search_value } } }

    it 'expect to use custom search key' do
      expect(scope).to receive(:find).with(search_value).and_return(found_instance)
      query_step.call(ctx, params)
      expect(ctx['model']).to eq found_instance
    end
  end
end
