# frozen_string_literal: true

RSpec.describe Macros::Params::Remap do
  subject(:remap_step) { described_class.new(mapper_class) }

  let(:mapper_class) do
    Class.new do
      def self.call; end

      self
    end
  end

  let(:params) { { rand => rand } }
  let(:remapped_params) { { rand => rand } }
  let(:options) { {} }

  it 'expect to use mapper class and assign result to params' do
    expect(mapper_class).to receive(:call).with(params).and_return(remapped_params)
    remap_step.call(options, params: params)
    expect(options['params']).to eq remapped_params
  end
end
