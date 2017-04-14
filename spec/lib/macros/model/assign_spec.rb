# frozen_string_literal: true

RSpec.describe Macros::Model::Assign do
  subject(:assign_step) { described_class.new(:resource) }

  let(:klass) do
    Class.new do
      attr_accessor :resource

      self
    end
  end

  let(:model) { klass.new }
  let(:key) { 'resource' }
  let(:value) { rand.to_s }

  it 'expect to assign options attribute under resource' do
    assign_step.call(key => value, 'model' => model)
    expect(model.resource).to eq value
  end
end
