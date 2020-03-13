module FacilitiesManagement
  module Beta
    module Supplier
      class ContractsController < FacilitiesManagement::Beta::Supplier::FrameworkController
        include FacilitiesManagement::ControllerLayoutHelper
        include FacilitiesManagement::Beta::Supplier::ContractsHelper

        before_action :set_contract
        before_action :set_procurement
        before_action :set_page_detail, only: %i[show edit]

        def show; end

        def edit; end

        def update
          @contract.assign_attributes(contract_params)
          if @contract.valid?(:contract_response)
            if @contract.contract_response
              @contract.accept!
            else
              @contract.decline!
            end
            redirect_to facilities_management_beta_supplier_contract_sent_index_path(@contract.id)
          else
            set_page_detail
            render :edit
          end
        end

        private

        def contract_params
          params.require(:facilities_management_procurement_supplier).permit(
            :reason_for_declining,
            :contract_response
          )
        end

        def set_contract
          @contract = ProcurementSupplier.find(params[:id])
        end

        def set_procurement
          @procurement = Procurement.find(@contract.procurement.id)
        end
      end
    end
  end
end
