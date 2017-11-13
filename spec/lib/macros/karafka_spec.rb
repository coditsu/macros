# frozen_string_literal: true

RSpec.describe Macros::Karafka do
  let(:scope) { Class.new }

  describe '#Broadcast()' do
    it { expect(described_class::Broadcast(scope)).to be_a described_class::Broadcast }
  end
end
