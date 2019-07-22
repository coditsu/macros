# frozen_string_literal: true

RSpec.describe_current do
  subject(:destroy_step) { described_class.new }

  let(:scope) do
    Class.new do
      def destroy; end

      self
    end
  end

  let(:model) { instance_double(scope) }

  it 'expect to destroy model' do
    expect(model).to receive(:destroy)
    destroy_step.call({}, model: model)
  end
end
