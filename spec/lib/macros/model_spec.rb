# frozen_string_literal: true

RSpec.describe_current do
  let(:scope) { Class.new }

  describe '#Build()' do
    it 'proxy to trbr model build' do
      expect(described_class::Build.new(scope).call[1]).to eq Trailblazer::Operation::Model(scope, :new)[1]
    end
  end

  describe '#Find()' do
    it { expect(described_class::Find.new(scope)).to be_a described_class::Find }
  end

  describe '#Destroy()' do
    it { expect(described_class::Destroy.new).to be_a described_class::Destroy }
  end

  describe '#Import()' do
    it { expect(described_class::Import.new(scope)).to be_a described_class::Import }
  end

  describe '#Persist()' do
    it { expect(described_class::Persist.new).to be_a described_class::Persist }
  end
end
