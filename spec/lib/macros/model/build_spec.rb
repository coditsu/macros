# frozen_string_literal: true
RSpec.describe Macros::Model::Build do
  subject(:build_step) { described_class.new(scope) }

  let(:scope) { Class.new }

  it 'expect to delegate to trbr contract build' do
    expect(Trailblazer::Operation).to receive(:Model)
      .with(scope, :new)

    build_step.call
  end
end
