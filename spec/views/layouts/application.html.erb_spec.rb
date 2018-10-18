require 'rails_helper'

RSpec.describe 'layouts/application.html.erb' do
  it 'displays flash error messages' do
    flash[:error] = 'error-message'

    render

    expect(rendered).to have_text('error-message')
  end

  describe 'feedback links' do
    let(:mail_to_link_selector) do
      %(a[href="mailto:#{feedback_email_address}"])
    end

    before do
      allow(Marketplace).to receive(:feedback_email_address)
        .and_return(feedback_email_address)
    end

    context 'when feedback email address is present' do
      let(:feedback_email_address) { 'feedback@example.com' }

      it 'displays link to feedback email address in beta banner' do
        render

        expect(rendered).to have_css(".govuk-phase-banner #{mail_to_link_selector}")
      end

      it 'displays link to feedback email address in footer' do
        render

        expect(rendered).to have_css(".govuk-footer #{mail_to_link_selector}")
      end
    end

    context 'when feedback email address is not present' do
      let(:feedback_email_address) { nil }

      it 'does not display link to feedback email address in beta banner' do
        render

        expect(rendered).not_to have_css(".govuk-phase-banner #{mail_to_link_selector}")
      end

      it 'does not display link to feedback email address in footer' do
        render

        expect(rendered).not_to have_css(".govuk-footer #{mail_to_link_selector}")
      end
    end
  end
end
