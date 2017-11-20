# frozen_string_literal: true

RSpec.describe Macros::Contract::Validate do
  subject(:validate_step) { described_class.new(*args) }

  context 'when non argument one' do
    let(:args) { [] }

    it 'expect to delegate to trbr contract build' do
      expect(Trailblazer::Operation::Contract).to receive(:Validate)
        .with(key: :data)

      validate_step.call
    end
  end

  context 'when argument one' do
    context 'when without a key' do
      let(:args) { [{ rand => rand }] }

      it 'expect to delegate to trbr contract build' do
        expect(Trailblazer::Operation::Contract).to receive(:Validate)
          .with(args.last.merge(key: :data))

        validate_step.call
      end
    end

    context 'when with a key' do
      let(:args) { [{ key: rand }] }

      it 'expect to delegate to trbr contract build' do
        expect(Trailblazer::Operation::Contract).to receive(:Validate)
          .with(*args)

        validate_step.call
      end
    end
  end
end
