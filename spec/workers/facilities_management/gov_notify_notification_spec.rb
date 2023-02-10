require 'rails_helper'

RSpec.describe FacilitiesManagement::GovNotifyNotification do
  describe '#send_email_notification' do
    let(:temp_args) do
      {
        subject: 'testing subject',
        'message-body': 'testing body'
      }.to_json
    end

    it 'sends an email' do
      stub_request(:post, 'https://api.notifications.service.gov.uk/v2/notifications/email').to_return(status: 200, body: '{}', headers: {})

      expect(
        described_class.send_email_notification('GENERIC_NOTIFICATION', 'test-email@crowncommercial.gov.uk', temp_args)
      ).to have_requested(:post, 'https://api.notifications.service.gov.uk/v2/notifications/email').with(
        body: { 'email_address' => 'test-email@crowncommercial.gov.uk', 'template_id' => nil, 'personalisation' => { 'subject' => 'testing subject', 'message-body' => 'testing body' } }
      )
    end
  end
end
