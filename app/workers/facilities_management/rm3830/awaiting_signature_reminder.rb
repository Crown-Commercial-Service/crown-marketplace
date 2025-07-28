module FacilitiesManagement
  module RM3830
    class AwaitingSignatureReminder
      include Sidekiq::Worker

      sidekiq_options queue: 'fm', retry: true

      def perform(id)
        contract = ProcurementSupplier.find(id)
        contract.send_reminder_email_to_buyer if contract.aasm_state == 'accepted'
      end
    end
  end
end
