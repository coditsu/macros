# frozen_string_literal: true

RSpec.describe Macros::Model::Search do
  let(:klass) do
    Class.new do
      def self.search(_current_search); end

      self
    end
  end

  let(:current_search) { { rand(100) => rand(100) } }
  let(:search) { OpenStruct.new(result: search_result) }
  let(:search_result) { [rand] }

  context 'when we want to search model' do
    subject(:paginate_step) { described_class.new }

    let(:options) { { 'model' => klass } }

    it 'expect to assign a model search' do
      expect(klass).to receive(:search).with(current_search).and_return(search)
      paginate_step.call(options, current_search: current_search)
      expect(options['model_search']).to eq search
    end

    it 'expect to assign a search result' do
      expect(klass).to receive(:search).with(current_search).and_return(search)
      paginate_step.call(options, current_search: current_search)
      expect(options['model']).to eq search_result
    end
  end

  context 'when we want to search different key' do
    subject(:paginate_step) { described_class.new(name: 'different') }

    let(:options) { { 'different' => klass } }

    it 'expect to assign a different search' do
      expect(klass).to receive(:search).with(current_search).and_return(search)
      paginate_step.call(options, current_search: current_search)
      expect(options['different_search']).to eq search
    end

    it 'expect to assign a different search result' do
      expect(klass).to receive(:search).with(current_search).and_return(search)
      paginate_step.call(options, current_search: current_search)
      expect(options['different']).to eq search_result
    end
  end
end
