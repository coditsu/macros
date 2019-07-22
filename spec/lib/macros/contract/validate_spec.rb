# frozen_string_literal: true

RSpec.describe_current do
  subject(:validate_step) { described_class.new(*args) }

  let(:args) { { rand => rand } }

  it 'expect to delegate to trbr contract build' do
    expect(Trailblazer::Operation::Contract).to receive(:Validate)
      .with(*args)

    validate_step.call
  end
end
