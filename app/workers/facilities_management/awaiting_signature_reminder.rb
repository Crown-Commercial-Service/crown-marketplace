module FacilitiesManagement
  class AwaitingSignatureReminder
    include Sidekiq::Worker
    sidekiq_options queue: 'fm', retry: true

    def perform(id)
      contract = FacilitiesManagement::ProcurementSupplier.find(id)
      contract.send_reminder_email_to_buyer if contract.aasm_state == 'accepted'
    end
  end
end
