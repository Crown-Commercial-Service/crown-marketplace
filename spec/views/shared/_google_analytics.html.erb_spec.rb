require 'rails_helper'

RSpec.describe 'shared/_google_analytics.html.erb' do
  context 'when Google Analytics tracking ID is missing' do
    before do
      allow(Marketplace).to receive(:ga_tracking_id).and_return(nil)
      render partial: 'shared/google_analytics'
    end

    it 'does not render anything' do
      expect(rendered).to be_blank
    end
  end

  context 'when Google Analytics tracking ID is set' do
    before do
      allow(Marketplace).to receive(:ga_tracking_id).and_return('UA-999-9')
      render partial: 'shared/google_analytics'
    end

    it 'displays the error summary' do
      expect(rendered).to match(/script/)
      expect(rendered).to match(/UA-999-9/)
    end
  end
end
