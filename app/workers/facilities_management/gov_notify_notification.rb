require 'notifications/client'
module FacilitiesManagement
  class GovNotifyNotification
    include Sidekiq::Worker
    sidekiq_options queue: 'fm', retry: true

    # Template Ids
    EMAIL_TEMPLATES = {
      RM3830_DA_generic_notification: 'cca9f44c-5ccd-45d6-865c-5305655a0f16',
      DA_offer_accepted: '284bde46-7898-4a92-a30a-0a3bf16cec75',
      DA_offer_accepted_signature_confirmation_reminder: '15072918-f908-4c0b-b76a-0585a2e31bb3',
      DA_offer_declined: 'a962eb14-5d8a-47c7-8997-d186c1fcbfde',
      DA_offer_no_response: '3441a397-c6bb-40e6-96b6-086a1d8c4ff6',
      DA_offer_accepted_not_signed: '78f6fc1c-43aa-494a-91c9-69fdd834be8c',
      DA_offer_sent: '263fa53d-0220-46cb-9fe9-1c167ac47461',
      DA_offer_sent_reminder: 'e05d2c2c-cc99-4be2-9dd3-ad9094907a25',
      DA_offer_signed_contract_live: '049f919a-1a3f-4f77-a65d-7212e66f2a0e',
      DA_offer_withdrawn: '48d9a7e9-ea5a-42d6-8e23-c1bcfe002da7'
    }.freeze

    def self.send_email_notification(template_name, email_to, template_args)
      @client = Notifications::Client.new(ENV.fetch('GOV_NOTIFY_API_KEY', nil))

      @client.send_email(
        email_address: email_to,
        template_id: EMAIL_TEMPLATES[template_name.to_sym],
        personalisation: JSON.parse(template_args)
      )
    end

    def perform(template_name, email_to, template_args)
      FacilitiesManagement::GovNotifyNotification.send_email_notification(template_name, email_to, template_args)
    end
  end
end
