# frozen_string_literal: true
RSpec.describe Macros::Model::Import do
  subject(:import_step) { described_class.new(klass, key: key, validate: validate) }

  let(:klass) { OpenStruct }
  let(:import_data) { Array.new(rand(20) + 1) { klass.new(id: rand.to_s, setup_state: rand, attributes: { id: 1, setup_state: 2 }) } }
  let(:key) { rand.to_s }
  let(:validate) { rand(2) == 0 }
  let(:options) { { key => import_data } }
  let(:attributes) { import_data.first.attributes.keys - ['id'] }
  let(:import_args) do
    [
      attributes,
      import_data,
      validate: validate,
      on_duplicate_key_ignore: true
    ]
  end

  it 'expect to import on klass' do
    expect(klass).to receive(:import).with(*import_args)

    import_step.call(options)
  end
end
