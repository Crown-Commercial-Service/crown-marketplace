module FacilitiesManagement
  module RM6232
    class ProcurementsController < FacilitiesManagement::FrameworkController
      def new
        @procurement = current_user.rm6232_procurements.build(service_codes: params[:service_codes],
                                                              region_codes: params[:region_codes],
                                                              annual_contract_value: params[:annual_contract_value])

        @procurement.lot_number = @procurement.quick_view_suppliers.lot_number
        @suppliers = @procurement.quick_view_suppliers.selected_suppliers
        @back_path = back_path
        @back_text = t('.return_to_contract_cost')
      end

      def create; end

      private

      def back_path
        helpers.journey_step_url_former(journey_slug: 'annual-contract-value', annual_contract_value: @procurement.annual_contract_value, region_codes: @procurement.region_codes, service_codes: @procurement.service_codes)
      end
    end
  end
end
