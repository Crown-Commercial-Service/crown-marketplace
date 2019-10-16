require 'facilities_management/fm_buildings_data'
module FacilitiesManagement
  module Beta
    class ProcurementBuildingsController < FrameworkController
      before_action :set_procurement_building
      before_action :set_building_data
      before_action :set_back_path

      def show; end

      private

      def set_procurement_building
        @procurement_building = FacilitiesManagement::ProcurementBuilding.find(params[:id])
      end

      def set_building_data
        fm_building_data = FMBuildingData.new
        @building = fm_building_data.get_building_data_by_id(current_user.email, @procurement_building.building_id).first
        @building_data = JSON.parse(@building['building_json'])
      end

      def set_back_path
        @back_link = facilities_management_beta_procurement_path(@procurement_building.procurement)
      end
    end
  end
end
