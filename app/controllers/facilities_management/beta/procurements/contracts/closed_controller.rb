module FacilitiesManagement
  module Beta
    module Procurements
      module Contracts
        class ClosedController < FacilitiesManagement::Beta::FrameworkController
          def index
            @procurement = @current_user.procurements.where(id: params[:procurement_id])&.first
            @contract = @procurement&.procurement_suppliers&.where(id: params[:contract_id])&.first
          end
        end
      end
    end
  end
end
