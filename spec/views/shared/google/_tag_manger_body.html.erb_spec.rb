require 'rails_helper'

RSpec.describe 'shared/google/_tag_manager_body.html.erb' do
  before do
    allow(Marketplace).to receive(:google_tag_manager_tracking_id)
      .and_return(google_tag_manager_tracking_id)
  end

  context 'when Google Tag Manager tracking ID is missing' do
    let(:google_tag_manager_tracking_id) { nil }

    it 'does not render anything' do
      render partial: 'shared/google/tag_manager_body'

      expect(rendered).to be_blank
    end
  end

  context 'when Google Tag Manager tracking ID is set' do
    let(:google_tag_manager_tracking_id) { 'UA-999-9' }

    it 'renders the Google Tag Manager tracking code' do
      render partial: 'shared/google/tag_manager_body'

      expect(rendered).to match(/noscript/)
      expect(rendered).to match(/iframe/)
      expect(rendered).to match(/UA-999-9/)
    end
  end
end
