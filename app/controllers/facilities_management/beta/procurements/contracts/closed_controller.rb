module FacilitiesManagement
  module Beta
    module Procurements
      module Contracts
        class ClosedController < FacilitiesManagement::Beta::FrameworkController
          def index
            @procurement = @current_user.procurements.find_by(id: params[:procurement_id])
            @contract = @procurement.procurement_suppliers.find_by(id: params[:contract_id])
          end
        end
      end
    end
  end
end
