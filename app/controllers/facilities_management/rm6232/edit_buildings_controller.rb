module FacilitiesManagement
  module RM6232
    class EditBuildingsController < FacilitiesManagement::BuildingsController
      private

      def index_path
        edit_facilities_management_rm6232_procurement_procurement_detail_path(@procurement, section: :buildings)
      end

      def show_path(building = @building)
        facilities_management_rm6232_procurement_edit_building_path(@procurement, building)
      end

      def edit_path(building, section)
        edit_facilities_management_rm6232_procurement_edit_building_path(@procurement, building, section:)
      end

      def create_path
        facilities_management_rm6232_procurement_edit_buildings_path(@procurement)
      end

      def update_path
        facilities_management_rm6232_procurement_edit_building_path(@procurement, @building, section:)
      end

      def start_a_procurement_path
        facilities_management_journey_question_path(slug: 'choose-services')
      end

      def set_procurement
        @procurement = Procurement.find(params[:procurement_id])
      end
    end
  end
end
