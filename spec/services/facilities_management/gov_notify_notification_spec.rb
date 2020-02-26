require 'rails_helper'

RSpec.describe FacilitiesManagement::GovNotifyNotification do
  describe 'Send email notifications' do
    let(:temp_args) do
      {
        'subject': 'testing subject',
        'message-body': 'testing body'
    }.to_json
    end

    it 'Send basic email' do
      stub_request(:post, 'https://api.notifications.service.gov.uk/v2/notifications/email').to_return(status: 200, body: '{}', headers: {})

      ENV['GOV_NOTIFY_API_KEY'] = 'ea34b16b-8fcc-4e8a-917c-fe546bb37ad1-300aedcc-3d5d-4f2a-84c3-3ff0d61c7792'
      notification = described_class.send_email_notification('GENERIC_NOTIFICATION', 'test-email@crowncommercial.gov.uk', temp_args)
      expect(notification).to eq(notification)
    end
  end
end
