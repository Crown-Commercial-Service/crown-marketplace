module FacilitiesManagement
  module Procurements
    class CopyProcurementController < FacilitiesManagement::FrameworkController
      include FacilitiesManagement::ControllerLayoutHelper
      include FacilitiesManagement::Procurements::CopyProcurementHelper

      before_action :set_procurement_data
      before_action :set_contract_data
      before_action :duplicate_procurement
      before_action :set_page_detail

      def new; end

      def create
        @procurement_copy.assign_attributes(procurement_params)
        if @procurement_copy.save(context: :contract_name)
          redirect_to facilities_management_procurement_path(@procurement_copy.id)
        else
          @errors = @procurement.errors
          set_procurement_data
          render :new
        end
      end

      private

      def set_procurement_data
        @procurement = current_user.procurements.find_by(id: params[:procurement_id])
      end

      def set_contract_data
        @contract = if find_contract_id.nil?
                      nil
                    else
                      @procurement.procurement_suppliers.find_by(id: find_contract_id)
                    end
      end

      def duplicate_procurement
        @procurement_copy = @procurement.create_procurement_copy
      end

      def procurement_params
        params.require(:facilities_management_procurement).permit(:contract_name)
      end
    end
  end
end
