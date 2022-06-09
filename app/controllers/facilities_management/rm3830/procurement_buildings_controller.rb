module FacilitiesManagement
  module RM3830
    class ProcurementBuildingsController < FacilitiesManagement::ProcurementBuildingsController
      before_action :set_volume_procurement_building_services, only: :show
      before_action :set_standards_procurement_building_services, only: :show

      def show; end

      private

      def set_procurement_building_data
        @procurement_building = ProcurementBuilding.find(params[:id])

        super
      end

      def set_procurement_data
        @procurement = Procurement.find(params[:procurement_id])
      end

      def set_volume_procurement_building_services
        @volume_procurement_building_services = @procurement_building.sorted_procurement_building_services.map do |procurement_building_service|
          procurement_building_service.required_volume_contexts.map do |context|
            { procurement_building_service: procurement_building_service, context: context[1].first }
          end
        end.flatten
      end

      def set_standards_procurement_building_services
        @standards_procurement_building_services = @procurement_building.sorted_procurement_building_services.select(&:requires_service_standard?)
      end

      def return_link
        section == :missing_region ? procurement_show_path : "/facilities-management/#{params[:framework]}/procurements/#{@procurement.id}/summary?summary=buildings_and_services"
      end

      def after_update_path
        "/facilities-management/#{params[:framework]}/procurements/#{@procurement.id}/summary?summary=buildings_and_services"
      end
    end
  end
end
