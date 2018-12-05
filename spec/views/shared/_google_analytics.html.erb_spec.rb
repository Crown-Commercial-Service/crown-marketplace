require 'rails_helper'

RSpec.describe 'shared/_google_analytics.html.erb' do
  context 'when GA_TRACKING_ID is missing' do
    before do
      stub_const('ENV', {})
      render partial: 'shared/google_analytics'
    end

    it 'does not render anything' do
      expect(rendered).to be_blank
    end
  end

  context 'when GA_TRACKING_ID is set' do
    before do
      stub_const('ENV', 'GA_TRACKING_ID' => 'UA-999-9')
      render partial: 'shared/google_analytics'
    end

    it 'displays the error summary' do
      expect(rendered).to match(/script/)
      expect(rendered).to match(/UA-999-9/)
    end
  end
end
