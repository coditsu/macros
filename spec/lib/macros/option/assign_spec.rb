# frozen_string_literal: true

RSpec.describe Macros::Option::Assign do
  let(:klass) { Class.new }
  let(:options) { {} }

  describe 'default options key' do
    subject(:assign_step) { described_class.new(klass) }

    it 'expect to assign under model key' do
      assign_step.call(options)
      expect(options['model']).to eq klass
    end
  end

  describe 'custom options key' do
    subject(:assign_step) { described_class.new(klass, name: name) }
    let(:name) { rand.to_s }

    it 'expect to assign under custom key' do
      assign_step.call(options)
      expect(options[name]).to eq klass
    end
  end
end
