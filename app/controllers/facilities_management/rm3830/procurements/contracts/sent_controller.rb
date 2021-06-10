module FacilitiesManagement
  module RM3830
    module Procurements
      module Contracts
        class SentController < FacilitiesManagement::FrameworkController
          def index
            @procurement = @current_user.procurements.find_by(id: params[:procurement_id])
            authorize! :manage, @procurement
            @contract = @procurement&.procurement_suppliers&.find_by(id: params[:contract_id])
            @supplier = @contract&.supplier
          end
        end
      end
    end
  end
end
