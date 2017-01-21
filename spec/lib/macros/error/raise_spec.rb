# frozen_string_literal: true

RSpec.describe Macros::Error::Raise do
  subject(:raise_step) { described_class.new(error_class) }

  let(:ctx) { { 'current_operation' => rand, 'current_step' => rand } }
  let(:args) { [{ rand => rand }] }
  let(:error_class) { Class.new(StandardError) }

  it 'expect to always raise error with details for debug' do
    expect { raise_step.call(ctx, *args) }.to raise_error error_class
  end
end
