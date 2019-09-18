# frozen_string_literal: true

RSpec.describe_current do
  subject(:import_step) do
    described_class.new(
      klass,
      key: key,
      except: except
    )
  end

  let(:klass) { OpenStruct }
  let(:key) { rand.to_s }
  let(:except) { [] }
  let(:ctx) { { key => import_data } }
  let(:attributes) { import_data.first.attributes.keys - ['id'] }

  context 'when we import multiple elements in array' do
    let(:import_args) do
      [
        attributes.map(&:to_s),
        import_data,
        validate: false,
        on_duplicate_key_ignore: true,
        on_duplicate_key_update: nil,
        batch_size: nil
      ]
    end

    let(:import_data) do
      Array.new(rand(1..20)) do
        klass.new(
          id: rand.to_s,
          setup_state: rand,
          attributes: { id: 1, setup_state: 2 }
        )
      end
    end

    it 'expect to import on klass' do
      expect(klass).to receive(:import).with(*import_args)

      import_step.call(ctx)
    end
  end

  context 'when we import single element' do
    let(:attributes) { import_data.attributes.keys - ['id'] }

    let(:import_args) do
      [
        attributes.map(&:to_s),
        [import_data],
        validate: false,
        on_duplicate_key_ignore: true,
        on_duplicate_key_update: nil,
        batch_size: nil
      ]
    end

    let(:import_data) do
      klass.new(
        id: rand.to_s,
        setup_state: rand,
        attributes: { id: 1, setup_state: 2 }
      )
    end

    it 'expect to import on klass' do
      expect(klass).to receive(:import).with(*import_args)

      import_step.call(ctx)
    end
  end

  context 'when we want to ignore a given field' do
    let(:except) { %i[setup_state] }

    let(:import_args) do
      [
        attributes.map(&:to_s) - %w[setup_state],
        import_data,
        validate: false,
        on_duplicate_key_ignore: true,
        on_duplicate_key_update: nil,
        batch_size: nil
      ]
    end

    let(:import_data) do
      Array.new(rand(1..20)) do
        klass.new(
          id: rand.to_s,
          setup_state: rand,
          attributes: { id: 1, setup_state: 2 }
        )
      end
    end

    it 'expect to import on klass' do
      expect(klass).to receive(:import).with(*import_args)

      import_step.call(ctx)
    end
  end
end
