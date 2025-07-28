module FacilitiesManagement
  module RM3830
    class GenerateContractZip
      include Sidekiq::Worker

      sidekiq_options queue: 'fm', retry: true

      def perform(contract_id)
        Procurements::Contracts::DocumentsGenerator.generate_final_zip(contract_id)
      end
    end
  end
end
