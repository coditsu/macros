# frozen_string_literal: true
RSpec.describe Macros::Params do
  describe '#Remap()' do
    let(:remapper_class) { Class.new }

    it { expect(described_class::Remap(remapper_class)).to be_a described_class::Remap }
  end
end
