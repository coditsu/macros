# frozen_string_literal: true
RSpec.describe Macros::Model::Find do
  subject(:find_step) { described_class.new(scope) }

  let(:scope) { Class.new }

  it 'expect to delegate to trbr contract build' do
    expect(Trailblazer::Operation).to receive(:Model)
      .with(scope, :find_by!)

    find_step.call
  end
end
