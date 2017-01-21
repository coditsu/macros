# frozen_string_literal: true

RSpec.describe Macros::Params do
  describe '#Remap()' do
    let(:from) { rand.to_s }
    let(:to) { rand.to_s }

    it { expect(described_class::Remap(from: from, to: to)).to be_a described_class::Remap }
  end
end
