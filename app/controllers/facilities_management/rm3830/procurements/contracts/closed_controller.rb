module FacilitiesManagement
  module RM3830
    module Procurements
      module Contracts
        class ClosedController < FacilitiesManagement::FrameworkController
          before_action :set_contract_and_procurement

          def index; end

          private

          def set_contract_and_procurement
            @procurement = @current_user.rm3830_procurements.find_by(id: params[:procurement_id])
            authorize! :manage, @procurement
            @contract = @procurement&.procurement_suppliers&.find_by(id: params[:contract_id])
          end
        end
      end
    end
  end
end
