require 'rails_helper'

RSpec.describe 'layouts/application.html.erb' do
  before do
    view.extend(ApplicationHelper)
    allow(view).to receive(:link_to_service_start_page).and_return('')
    controller.singleton_class.class_eval do
      def logged_in?
        true
      end
      helper_method :logged_in?

      def ccs_homepage_url
        'https://CCSHOMEPAGE'
      end
      helper_method :ccs_homepage_url
    end
  end

  describe 'feedback links' do
    let(:support_mail_to_link_selector) do
      %(a[href="mailto:#{support_email_address}"])
    end

    let(:feedback_mail_to_link_selector) do
      %(a[href="mailto:#{feedback_email_address}"])
    end

    before do
      allow(Marketplace).to receive(:feedback_email_address)
        .and_return(feedback_email_address)
      allow(Marketplace).to receive(:support_email_address)
        .and_return(support_email_address)
    end

    context 'when feedback email address is present' do
      let(:feedback_email_address) { 'feedback@something.com' }
      let(:support_email_address) { 'support@something.com' }

      it 'displays link to feedback email address in beta banner' do
        render

        expect(rendered).to have_css(".govuk-phase-banner #{feedback_mail_to_link_selector}")
      end

      it 'displays link to support email address above footer' do
        render

        expect(rendered).to have_css(".footer-feedback #{support_mail_to_link_selector}")
      end
    end
  end

  it 'includes google analytics partial' do
    stub_template 'shared/_google_analytics.html.erb' => 'GA GA GA GA'
    render
    expect(rendered).to match(/GA GA GA GA/)
  end

  it 'renders the page title stored in the locale file' do
    render
    expected = t('layouts.application.title')
    expect(rendered).to have_css('title', text: expected, visible: false)
  end

  it 'adds an optional prefix to the page title' do
    view.content_for(:page_title_prefix) { 'Prefix' }
    render
    expected = 'Prefix: ' + t('layouts.application.title')
    expect(rendered).to have_css('title', text: expected, visible: false)
  end
end
