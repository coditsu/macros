# frozen_string_literal: true

RSpec.describe Macros::Params::Remap do
  subject(:remap_step) { described_class.new(from: from, to: to) }

  let(:from) { :a }
  let(:to) { :b }
  let(:value) { rand }
  let(:params) { { from => value } }
  let(:remapped_params) { { to => value, from => value } }
  let(:ctx) { {} }

  it 'expect to copy params key into a proper new one' do
    remap_step.call(ctx, params: params)
    expect(params).to eq remapped_params
  end
end
