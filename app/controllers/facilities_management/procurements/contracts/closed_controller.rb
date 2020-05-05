module FacilitiesManagement
  module Procurements
    module Contracts
      class ClosedController < FacilitiesManagement::FrameworkController
        def index
          @procurement = @current_user.procurements.find_by(id: params[:procurement_id])
          @contract = @procurement.procurement_suppliers.find_by(id: params[:contract_id])
        end
      end
    end
  end
end
