# frozen_string_literal: true

RSpec.describe Macros::Params::Fetch do
  subject(:fetch_step) { described_class.new(from: from, to: to) }

  let(:from) { :a }
  let(:to) { rand }
  let(:params) { { rand => rand, a: 1 } }
  let(:options) { {} }

  it 'expect to fetch proper value from params to options' do
    fetch_step.call(options, params: params)
    expect(options[to]).to eq params[from]
  end

  context 'when to is not provided' do
    let(:to) { nil }

    it 'expect to use same key as from' do
      fetch_step.call(options, params: params)
      expect(options[from]).to eq params[from]
    end
  end
end