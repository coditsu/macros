# frozen_string_literal: true
RSpec.describe Macros::Model::Persist do
  let(:scope) do
    Class.new do
      def save!; end

      def save; end

      self
    end
  end

  let(:model) { instance_double(scope) }

  describe 'default save!' do
    subject(:persist_step) { described_class.new }

    it 'expect to save model' do
      expect(model).to receive(:save!)
      persist_step.call({}, model: model)
    end
  end

  describe 'different save method' do
    subject(:persist_step) { described_class.new(method: :save) }

    it 'expect to save model' do
      expect(model).to receive(:save)
      persist_step.call({}, model: model)
    end
  end
end
