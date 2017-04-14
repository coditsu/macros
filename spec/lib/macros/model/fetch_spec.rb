# frozen_string_literal: true

RSpec.describe Macros::Model::Fetch do
  let(:klass) do
    Class.new do
      attr_reader :resource

      def initialize(resource)
        @resource = resource
      end

      self
    end
  end

  let(:resource) { rand }
  let(:model) { klass.new(resource) }

  context 'when we want to fetch under resource name' do
    subject(:fetch_step) { described_class.new(:resource) }

    let(:options) { { 'model' => model } }

    it 'expect to retrieve resource and assign it' do
      fetch_step.call(options)
      expect(options['resource']).to eq resource
    end
  end

  context 'when we want to fetch from different key' do
    subject(:fetch_step) { described_class.new(:resource, from: 'different_model') }

    let(:options) { { 'different_model' => model } }

    it 'expect to retrieve resource and assign it' do
      fetch_step.call(options)
      expect(options['resource']).to eq resource
    end
  end

  context 'when we want to fetch and save under different key' do
    subject(:fetch_step) { described_class.new(:resource, to: 'different_target') }

    let(:options) { { 'model' => model } }

    it 'expect to retrieve resource and assign it' do
      fetch_step.call(options)
      expect(options['different_target']).to eq resource
    end
  end
end
