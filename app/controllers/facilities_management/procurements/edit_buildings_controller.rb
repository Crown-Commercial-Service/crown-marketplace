module FacilitiesManagement
  module Procurements
    class EditBuildingsController < FacilitiesManagement::FrameworkController
      include Procurements::EditBuildingsControllerDefinitions
      include Procurements::EditBuildingsControllerNavigation
      include FacilitiesManagement::FindAddressConcern
      include SharedBuildingsControllerMethods

      before_action :set_procurement
      before_action :initialise_page_data
      before_action :create_new_building, only: :new
      before_action :build_page_data, only: %i[show edit update add_address]
      before_action :authorize_user
      before_action :build_page_description, only: %i[show new edit add_address]
      before_action :initialize_building_details, only: :show

      def new; end

      def add_address; end

      def show; end

      def edit; end

      def create
        create_building_action
      end

      def update
        update_building_action
      end

      private

      def add_address_form_details
        @add_address_form_details ||= if id_present?
                                        { url: facilities_management_procurement_edit_building_path(@page_data[:model_object].id, procurement_id: @procurement.id), method: :patch }
                                      else
                                        { url: facilities_management_procurement_edit_buildings_path, method: :post }
                                      end
      end

      helper_method :step_title, :step_footer, :add_address_form_details, :valid_regions, :region_needs_resolution?, :multiple_regions?

      def set_procurement
        @procurement = current_user.procurements.find(params[:procurement_id])
      end

      protected

      def authorize_user
        @page_data[:model_object].present? && (@page_data[:model_object].is_a? Building) ? (authorize! :manage, @page_data[:model_object]) : (authorize! :read, FacilitiesManagement)
      end
    end
  end
end
