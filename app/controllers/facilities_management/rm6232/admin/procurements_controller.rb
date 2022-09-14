module FacilitiesManagement
  module RM6232
    module Admin
      class ProcurementsController < FacilitiesManagement::Admin::FrameworkController
        before_action :set_paginated_procurements, only: %i[index search_procurements]

        def index; end

        def show; end

        def search_procurements
          respond_to do |format|
            format.js
          end
        end

        private

        def set_paginated_procurements
          search_value = "%#{search_params[:search_value]}%".downcase

          @paginated_procurements = Procurement.select(:id, :contract_name, :updated_at, :aasm_state, :contract_number)
                                               .where('lower(contract_name) like ? or lower(contract_number) like ?', search_value, search_value)
                                               .order(updated_at: :desc)
                                               .page(params[:page])
                                               .per(50)
        end

        def search_params
          params.permit(:search_value)
        end
      end
    end
  end
end
