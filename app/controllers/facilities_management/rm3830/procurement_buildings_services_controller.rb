module FacilitiesManagement
  module RM3830
    class ProcurementBuildingsServicesController < FacilitiesManagement::FrameworkController
      before_action :set_building_and_service_data
      before_action :authorize_user
      before_action :set_partial
      before_action :redirect_if_unrecognised_step, only: :edit
      before_action :create_first_lift, if: -> { @partial_prefix == 'lifts' }, only: :edit

      def edit; end

      def update
        case params[:facilities_management_rm3830_procurement_building_service][:service_question]
        when 'lifts'
          update_procurement_building_service(lift_params, :lifts)
        when 'service_hours'
          update_procurement_building_service(service_hours_params, :service_hours)
        when 'volumes'
          update_procurement_building_service(volume_params, :volume)
        when 'service_standards'
          update_procurement_building_service(service_standards_params, :service_standard)
        when 'area'
          update_building_area
        else
          redirect_to facilities_management_rm3830_procurement_building_path(@procurement_building)
        end
      end

      private

      def update_procurement_building_service(pbs_params, context)
        @building_service.assign_attributes(pbs_params)

        if @building_service.save(context:)
          redirect_to facilities_management_rm3830_procurement_building_path(@procurement_building)
        else
          params[:service_question] = params[:facilities_management_rm3830_procurement_building_service][:service_question]
          set_partial
          render :edit
        end
      end

      def update_building_area
        @building.assign_attributes(area_params)

        if building_valid?
          @building.save
          redirect_to facilities_management_rm3830_procurement_building_path(@procurement_building)
        else
          params[:service_question] = params[:facilities_management_rm3830_procurement_building_service][:service_question]
          set_partial
          render :edit
        end
      end

      def building_valid?
        return false unless @building.valid?(:building_area)

        @building.errors.add(:gia, :required) unless @procurement_building.valid?(:gia)
        @building.errors.add(:external_area, :required) unless @procurement_building.valid?(:external_area)

        @building.errors.empty?
      end

      def set_partial
        @partial_prefix = params[:service_question]
      end

      def lift_params
        params.require(:facilities_management_rm3830_procurement_building_service)
              .permit(lifts_attributes: %i[id number_of_floors _destroy])
      end

      def service_hours_params
        params.require(:facilities_management_rm3830_procurement_building_service)
              .permit(:service_hours, :detail_of_requirement)
      end

      def volume_params
        params.require(:facilities_management_rm3830_procurement_building_service)
              .permit(:no_of_appliances_for_testing,
                      :no_of_building_occupants,
                      :no_of_consoles_to_be_serviced,
                      :tones_to_be_collected_and_removed,
                      :no_of_units_to_be_serviced)
      end

      def service_standards_params
        params.require(:facilities_management_rm3830_procurement_building_service)
              .permit(:service_standard)
      end

      def area_params
        params.require(:facilities_management_building)
              .permit(:gia, :external_area)
      end

      def set_building_and_service_data
        @building_service = ProcurementBuildingService.find_by id: params[:id]
        @procurement_building = @building_service.procurement_building
        @building = @procurement_building.building
        @procurement = @procurement_building.procurement
      end

      def create_first_lift
        @building_service.lifts.build if @building_service.lifts.empty?
      end

      def redirect_if_unrecognised_step
        redirect_to facilities_management_rm3830_procurement_building_path(@procurement_building) unless RECOGNISED_STEPS.include? @partial_prefix
      end

      RECOGNISED_STEPS = %w[lifts service_hours volumes service_standards area].freeze

      protected

      def authorize_user
        authorize! :manage, @procurement
      end
    end
  end
end
