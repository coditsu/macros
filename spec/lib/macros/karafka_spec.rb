# frozen_string_literal: true

RSpec.describe_current do
  let(:scope) { Class.new }

  describe '#Broadcast()' do
    it { expect(described_class::Broadcast.new(scope)).to be_a described_class::Broadcast }
  end
end
