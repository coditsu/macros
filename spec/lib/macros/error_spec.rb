# frozen_string_literal: true
RSpec.describe Macros::Error do
  describe '#Raise()' do
    it { expect(described_class::Raise(Class.new)).to be_a described_class::Raise }
  end
end
