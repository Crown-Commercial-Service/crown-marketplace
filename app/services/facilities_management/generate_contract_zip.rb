require 'notifications/client'
module FacilitiesManagement
  class GenerateContractZip
    include Sidekiq::Worker
    def perform(contract_id)
      FacilitiesManagement::Procurements::DocumentsProcurementHelper.generate_final_zip(contract_id)
    end
  end
end
