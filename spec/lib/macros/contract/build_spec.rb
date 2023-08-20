# frozen_string_literal: true

RSpec.describe_current do
  subject(:call) { instance.call }

  let(:instance) { described_class.new(args) }
  let(:args) { { name: 'random_name' } }

  it { expect { call }.not_to raise_error }
  it { is_expected.to be_a(Hash) }
end
