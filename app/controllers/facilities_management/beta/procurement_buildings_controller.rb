require 'facilities_management/fm_buildings_data'
module FacilitiesManagement
  module Beta
    class ProcurementBuildingsController < FrameworkController
      before_action :set_procurement_building
      before_action :set_building_data
      before_action :set_back_path

      def show; end

      def edit; end

      def update
        if @procurement_building.update(procurement_building_params)
          redirect_to facilities_management_beta_procurement_building_path(@procurement_building)
        else
          render :edit
        end
      end

      private

      def procurement_building_params
        params.require(:facilities_management_procurement_building)
              .permit(
                procurement_building_services_attributes: %i[id
                                                             no_of_appliances_for_testing
                                                             no_of_building_occupants
                                                             no_of_units_to_be_serviced
                                                             size_of_external_area
                                                             no_of_consoles_to_be_serviced
                                                             tones_to_be_collected_and_removed]
              )
      end

      def set_procurement_building
        @procurement_building = current_user.procurements.map(&:procurement_buildings).flatten.select { |pb| pb.id == params[:id] } .first
      end

      def set_building_data
        fm_building_data = FMBuildingData.new
        @building = fm_building_data.get_building_data_by_id(current_user.email, @procurement_building.building_id).first
        @building_data = JSON.parse(@building['building_json'])
      end

      def set_back_path
        @back_link = :back
      end
    end
  end
end
