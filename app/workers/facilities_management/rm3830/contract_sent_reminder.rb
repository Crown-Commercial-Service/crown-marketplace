module FacilitiesManagement
  module RM3830
    class ContractSentReminder
      include Sidekiq::Worker

      sidekiq_options queue: 'fm', retry: true

      def perform(id)
        contract = ProcurementSupplier.find(id)
        contract.send_reminder_email_to_suppiler if contract.aasm_state == 'sent'
      end
    end
  end
end
