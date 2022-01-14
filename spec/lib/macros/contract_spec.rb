# frozen_string_literal: true

RSpec.describe_current do
  describe '#Build()' do
    it 'proxy to trbr contract build' do
      expect(described_class::Build.new.call[1]).to eq Trailblazer::Operation::Contract::Build()[1]
    end
  end

  describe '#Validate()' do
    it 'proxy to trbr contract validate' do
      expect(described_class::Validate.new.call[1]).to eq Trailblazer::Operation::Contract::Validate()[1]
    end
  end

  describe '#Persist()' do
    it 'proxy to trbr contract persist' do
      expect(described_class::Persist.new.call[1]).to eq Trailblazer::Operation::Contract::Persist()[1]
    end
  end
end
