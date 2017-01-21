# frozen_string_literal: true
RSpec.describe Macros::Contract::Persist do
  subject(:persist_step) { described_class.new(*args) }

  let(:args) { { rand => rand } }

  it 'expect to delegate to trbr contract build' do
    expect(Trailblazer::Operation::Contract).to receive(:Persist)
      .with(*args)

    persist_step.call
  end
end
