module FacilitiesManagement
  module Procurements
    module Contracts
      class ClosedController < FacilitiesManagement::FrameworkController
        before_action :set_contract_and_procurement
        before_action :authorize_user

        def index; end

        private

        def set_contract_and_procurement
          @procurement = @current_user.procurements.find_by(id: params[:procurement_id])
          @contract = @procurement.procurement_suppliers.find_by(id: params[:contract_id])
        end

        protected

        def authorize_user
          authorize! :manage, @procurement
        end
      end
    end
  end
end
