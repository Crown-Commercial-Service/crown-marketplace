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
    end
  end
end
