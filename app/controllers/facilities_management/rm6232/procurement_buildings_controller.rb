module FacilitiesManagement
  module RM6232
    class ProcurementBuildingsController < FacilitiesManagement::FrameworkController
      before_action :set_procurement_building_data
      before_action :authorize_user

      def edit; end

      def update
        @procurement_building.assign_attributes(procurement_building_params)

        if @procurement_building.save(context: :buildings_and_services)
          redirect_to facilities_management_rm6232_procurement_detail_path(@procurement, section: 'buildings-and-services')
        else
          render :edit
        end
      end

      private

      def procurement_building_params
        params.require(:facilities_management_rm6232_procurement_building)
              .permit(service_codes: [])
      end

      def set_procurement_building_data
        @procurement_building = ProcurementBuilding.find(params[:id])
        @procurement = @procurement_building.procurement
      end

      protected

      def authorize_user
        authorize! :manage, @procurement
      end
    end
  end
end
