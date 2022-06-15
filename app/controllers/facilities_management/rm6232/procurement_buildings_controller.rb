module FacilitiesManagement
  module RM6232
    class ProcurementBuildingsController < FacilitiesManagement::ProcurementBuildingsController
      private

      def set_procurement_building_data
        @procurement_building = ProcurementBuilding.find(params[:id])

        super
      end

      def set_procurement_data
        @procurement = Procurement.find(params[:procurement_id])
      end

      def return_link
        section == :missing_region ? procurement_show_path : "/facilities-management/#{params[:framework]}/procurements/#{@procurement.id}/details/buildings-and-services"
      end

      def after_update_path
        "/facilities-management/#{params[:framework]}/procurements/#{@procurement.id}/details/buildings-and-services"
      end
    end
  end
end
