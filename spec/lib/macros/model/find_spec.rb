# frozen_string_literal: true
RSpec.describe Macros::Model::Find do
  subject(:find_step) { described_class.new(scope) }
  let(:options) { {} }
  let(:found_instance) { scope.new }
  let(:id_value) { rand }

  let(:scope) do
    Class.new do
      def self.find_by!(*args); end

      self
    end
  end

  it 'expect to find and assign to model' do
    expect(scope).to receive(:find_by!).with(id: id_value).and_return(found_instance)
    find_step.call(options, params: { id: id_value })
    expect(options['model']).to eq found_instance
  end
end
