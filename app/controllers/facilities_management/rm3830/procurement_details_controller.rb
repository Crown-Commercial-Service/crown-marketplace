module FacilitiesManagement
  module RM3830
    class ProcurementDetailsController < FacilitiesManagement::ProcurementDetailsController
      private

      def set_procurement
        @procurement = Procurement.find(params[:procurement_id])
      end

      RECOGNISED_DETAILS_EDIT_STEPS = %i[contract_name estimated_annual_cost tupe contract_period services buildings].freeze
      RECOGNISED_DETAILS_SHOW_PAGES = %i[contract_period services buildings buildings_and_services service_requirements].freeze
    end
  end
end
