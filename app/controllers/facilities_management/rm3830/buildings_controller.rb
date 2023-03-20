module FacilitiesManagement
  module RM3830
    class BuildingsController < FacilitiesManagement::BuildingsController
      private

      def index_path
        facilities_management_rm3830_buildings_path
      end

      def show_path(building = @building)
        facilities_management_rm3830_building_path(building)
      end

      def edit_path(building, section)
        edit_facilities_management_rm3830_building_path(building, section:)
      end

      def create_path
        facilities_management_rm3830_buildings_path
      end

      def update_path
        facilities_management_rm3830_building_path(@building, section:)
      end

      def start_a_procurement_path
        facilities_management_rm3830_what_happens_next_path
      end
    end
  end
end
