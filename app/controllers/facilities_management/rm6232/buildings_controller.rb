module FacilitiesManagement
  module RM6232
    class BuildingsController < FacilitiesManagement::BuildingsController
      private

      def index_path
        facilities_management_rm6232_buildings_path
      end

      def show_path(building = @building)
        facilities_management_rm6232_building_path(building)
      end

      def edit_path(building, section)
        edit_facilities_management_rm6232_building_path(building, section:)
      end

      def create_path
        facilities_management_rm6232_buildings_path
      end

      def update_path
        facilities_management_rm6232_building_path(@building, section:)
      end

      def start_a_procurement_path
        facilities_management_journey_question_path(slug: 'choose-services')
      end
    end
  end
end
