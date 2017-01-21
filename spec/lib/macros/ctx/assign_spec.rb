# frozen_string_literal: true

RSpec.describe Macros::Ctx::Assign do
  let(:klass) { Class.new }
  let(:ctx) { {} }

  describe 'default ctx key' do
    subject(:assign_step) { described_class.new(klass) }

    it 'expect to assign under model key' do
      assign_step.call(ctx)
      expect(ctx['model']).to eq klass
    end
  end

  describe 'custom ctx key' do
    subject(:assign_step) { described_class.new(klass, name: name) }

    let(:name) { rand.to_s }

    it 'expect to assign under custom key' do
      assign_step.call(ctx)
      expect(ctx[name]).to eq klass
    end
  end
end
