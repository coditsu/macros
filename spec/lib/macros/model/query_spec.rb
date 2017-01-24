# frozen_string_literal: true
RSpec.describe Macros::Model::Query do
  let(:options) { {} }
  let(:found_instance) { scope.new }
  let(:search_value) { rand }

  let(:scope) do
    Class.new do
      def self.find_by!(*args); end
      def self.find_by(*args); end

      self
    end
  end

  context 'default case' do
    subject(:query_step) { described_class.new(scope) }

    let(:params) { { params: { id: search_value } } }

    it 'expect to use default for querying and assignment' do
      expect(scope).to receive(:find_by!).with(id: search_value).and_return(found_instance)
      query_step.call(options, params)
      expect(options['model']).to eq found_instance
    end
  end

  context 'custom name assignment usage' do
    subject(:query_step) { described_class.new(scope, name: name) }

    let(:name) { rand }
    let(:params) { { params: { id: search_value } } }

    it 'expect to assign under custom name' do
      expect(scope).to receive(:find_by!).with(id: search_value).and_return(found_instance)
      query_step.call(options, params)
      expect(options[name]).to eq found_instance
    end
  end

  context 'custom action' do
    subject(:query_step) { described_class.new(scope, action) }

    let(:action) { :find_by }
    let(:params) { { params: { id: search_value } } }

    it 'expect to use custom query method' do
      expect(scope).to receive(:find_by).with(id: search_value).and_return(found_instance)
      query_step.call(options, params)
      expect(options['model']).to eq found_instance
    end
  end

  context 'custom search key' do
    subject(:query_step) { described_class.new(scope, search_key: search_key) }

    let(:search_key) { rand }
    let(:params) { { params: { id: search_value } } }

    it 'expect to use custom search key' do
      expect(scope).to receive(:find_by!).with(search_key => search_value).and_return(found_instance)
      query_step.call(options, params)
      expect(options['model']).to eq found_instance
    end
  end

  context 'custom params key' do
    subject(:query_step) { described_class.new(scope, params_key: params_key) }

    let(:params_key) { rand }
    let(:params) { { params: { params_key => search_value } } }

    it 'expect to use custom search key' do
      expect(scope).to receive(:find_by!).with(id: search_value).and_return(found_instance)
      query_step.call(options, params)
      expect(options['model']).to eq found_instance
    end
  end
end
