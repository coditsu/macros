# frozen_string_literal: true

RSpec.describe_current do
  let(:klass) do
    Class.new do
      def self.page(_page_number); end

      self
    end
  end

  let(:current_page) { rand(100) }
  let(:page) { rand }

  context 'when we want to paginate model' do
    subject(:paginate_step) { described_class.new }

    let(:ctx) { { 'model' => klass } }

    it 'expect to retrieve a given page' do
      expect(klass).to receive(:page).with(current_page).and_return(page)
      paginate_step.call(ctx, current_page: current_page)
      expect(ctx['model']).to eq page
    end
  end

  context 'when we want to paginate a different ctx key resource' do
    subject(:paginate_step) { described_class.new(name: 'different') }

    let(:ctx) { { 'different' => klass } }

    it 'expect to retrieve a given page' do
      expect(klass).to receive(:page).with(current_page).and_return(page)
      paginate_step.call(ctx, current_page: current_page)
      expect(ctx['different']).to eq page
    end
  end
end
