# frozen_string_literal: true

RSpec.describe_current do
  describe '#Raise()' do
    it { expect(described_class::Raise.new(Class.new)).to be_a described_class::Raise }
  end
end
