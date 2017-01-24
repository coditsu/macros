# frozen_string_literal: true
RSpec.describe Macros::Model do
  let(:scope) { Class.new }

  describe '#Build()' do
    it 'proxy to trbr model build' do
      expect(described_class::Build(scope)[1]).to eq Trailblazer::Operation::Model(scope, :new)[1]
    end
  end

  describe '#Find()' do
    it { expect(described_class::Find(scope)).to be_a described_class::Find }
  end

  describe '#Query()' do
    it { expect(described_class::Query(scope)).to be_a described_class::Query }
  end

  describe '#Destroy()' do
    it { expect(described_class::Destroy()).to be_a described_class::Destroy }
  end

  describe '#Import()' do
    it { expect(described_class::Import(scope)).to be_a described_class::Import }
  end
end
