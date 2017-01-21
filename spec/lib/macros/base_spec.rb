# frozen_string_literal: true

RSpec.describe Macros::Base do
  subject(:container) { described_class.new(*args) }

  let(:args) { [{ rand => rand }] }

  describe '.new' do
    it 'expect to store arguments' do
      expect(container.send(:args)).to eq args
    end
  end
end
