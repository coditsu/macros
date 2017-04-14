# frozen_string_literal: true

RSpec.describe Macros do
  subject(:macros) { described_class }

  describe '#gem_root' do
    it 'expect to point to root of the gem' do
      expect(macros.gem_root).to eq File.expand_path('../../..', __FILE__)
    end
  end
end
