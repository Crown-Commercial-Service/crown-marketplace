module FacilitiesManagement
  module Procurements
    module Contracts
      class SentController < FacilitiesManagement::FrameworkController
        def index
          @procurement = @current_user.procurements.where(id: params[:procurement_id])&.first
          @contract = @procurement&.procurement_suppliers&.where(id: params[:contract_id])&.first
          @supplier = @contract&.supplier
        end
      end
    end
  end
end
