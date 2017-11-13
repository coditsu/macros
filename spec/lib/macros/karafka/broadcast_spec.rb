# frozen_string_literal: true

RSpec.describe Macros::Karafka::Broadcast do
  subject(:broadcast_step) { described_class.new(responder_class, name: name) }

  let(:options) { { name => rand } }
  let(:name) { rand.to_s }
  let(:responder_class) do
    Class.new do
      def self.call(broadcasted_resource); end
    end
  end

  it 'expect to assign options attribute under resource' do
    expect(responder_class).to receive(:call).with(options[name])
    broadcast_step.call(options)
  end
end
