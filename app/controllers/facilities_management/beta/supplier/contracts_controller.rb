module FacilitiesManagement
  module Beta
    module Supplier
      class ContractsController < FacilitiesManagement::Beta::Supplier::FrameworkController
        before_action :set_contract
        before_action :set_procurement

        def show; end

        def edit; end

        private

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
