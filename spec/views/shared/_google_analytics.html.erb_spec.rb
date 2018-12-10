require 'rails_helper'

RSpec.describe 'shared/_google_analytics.html.erb' do
  before do
    allow(Marketplace).to receive(:ga_tracking_id).and_return(ga_tracking_id)
  end

  context 'when Google Analytics tracking ID is missing' do
    let(:ga_tracking_id) { nil }

    it 'does not render anything' do
      render partial: 'shared/google_analytics'

      expect(rendered).to be_blank
    end
  end

  context 'when Google Analytics tracking ID is set' do
    let(:ga_tracking_id) { 'UA-999-9' }

    it 'displays the error summary' do
      render partial: 'shared/google_analytics'

      expect(rendered).to match(/script/)
      expect(rendered).to match(/UA-999-9/)
    end
  end
end
