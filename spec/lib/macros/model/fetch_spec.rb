# frozen_string_literal: true

RSpec.describe_current do
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

    let(:ctx) { { 'model' => model } }

    it 'expect to retrieve resource and assign it' do
      fetch_step.call(ctx)
      expect(ctx['resource']).to eq resource
    end
  end

  context 'when we want to fetch from different key' do
    subject(:fetch_step) { described_class.new(:resource, from: 'different_model') }

    let(:ctx) { { 'different_model' => model } }

    it 'expect to retrieve resource and assign it' do
      fetch_step.call(ctx)
      expect(ctx['resource']).to eq resource
    end
  end

  context 'when we want to fetch and save under different key' do
    subject(:fetch_step) { described_class.new(:resource, to: 'different_target') }

    let(:ctx) { { 'model' => model } }

    it 'expect to retrieve resource and assign it' do
      fetch_step.call(ctx)
      expect(ctx['different_target']).to eq resource
    end
  end
end
