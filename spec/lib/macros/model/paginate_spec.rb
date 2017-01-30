# frozen_string_literal: true
RSpec.describe Macros::Model::Paginate do
  let(:klass) do
    Class.new do
      def self.page(page_number); end

      self
    end
  end

  let(:current_page) { rand(100) }
  let(:page) { rand }

  context 'when we want to paginate model' do
    subject(:paginate_step) { described_class.new() }
    let(:options) { { 'model' => klass } }

    it 'expect to retrieve a given page' do
      expect(klass).to receive(:page).with(current_page).and_return(page)
      paginate_step.call(options, current_page: current_page)
      expect(options['model']).to eq page
    end
  end

  context 'when we want to paginate a different options key resource' do
    subject(:paginate_step) { described_class.new(name: 'different') }
    let(:options) { { 'different' => klass } }

    it 'expect to retrieve a given page' do
      expect(klass).to receive(:page).with(current_page).and_return(page)
      paginate_step.call(options, current_page: current_page)
      expect(options['different']).to eq page
    end
  end
end
