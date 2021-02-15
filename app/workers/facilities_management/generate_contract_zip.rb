module FacilitiesManagement
  class GenerateContractZip
    include Sidekiq::Worker
    sidekiq_options queue: 'fm', retry: true

    def perform(contract_id)
      FacilitiesManagement::Procurements::DocumentsProcurementHelper.generate_final_zip(contract_id)
    end
  end
end
