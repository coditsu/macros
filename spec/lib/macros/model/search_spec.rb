# frozen_string_literal: true

RSpec.describe_current do
  let(:klass) do
    Class.new do
      def self.ransack(_current_search); end

      self
    end
  end

  let(:current_search) { { rand(100) => rand(100) } }
  let(:search) { OpenStruct.new(result: search_result, sorts: sorts) }
  let(:search_result) { [rand] }
  let(:sorts) { [] }

  before do
    allow(klass).to receive(:search).with(current_search).and_return(search)
    paginate_step.call(ctx, current_search: current_search)
  end

  context 'when we want to search model' do
    subject(:paginate_step) { described_class.new }

    let(:ctx) { { 'model' => klass } }

    it 'expect to assign a model search' do
      expect(ctx['model_search']).to eq search
    end

    it 'expect to assign a search result' do
      expect(ctx['model']).to eq search_result
    end
  end

  context 'when we want to search different key' do
    subject(:paginate_step) { described_class.new(name: 'different') }

    let(:ctx) { { 'different' => klass } }

    it 'expect to assign a different search' do
      expect(ctx['different_search']).to eq search
    end

    it 'expect to assign a different search result' do
      expect(ctx['different']).to eq search_result
    end
  end

  context 'when we want to search with default_sort_order' do
    subject(:paginate_step) { described_class.new(default_sort_order: sort_order) }

    let(:sort_order) { rand.to_s }
    let(:ctx) { { 'model' => klass } }

    context 'when there are sorts loaded already' do
      let(:sorts) { [rand.to_s] }

      it { expect(ctx['model_search'].sorts).to eq sorts }
    end

    context 'when there is no sorts and we have our default' do
      let(:sorts) { [] }

      it { expect(ctx['model_search'].sorts).to eq [sort_order] }
    end
  end
end
