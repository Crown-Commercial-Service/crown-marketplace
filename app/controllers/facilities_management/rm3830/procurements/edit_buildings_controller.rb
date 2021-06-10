module FacilitiesManagement
  module RM3830
    module Procurements
      class EditBuildingsController < FacilitiesManagement::FrameworkController
        include Procurements::EditBuildingsControllerNavigation
        include FacilitiesManagement::PageDetail::Buildings
        include FacilitiesManagement::FindAddressConcern
        include BuildingsConcern

        private

        def add_address_form_details
          @add_address_form_details ||= if id_present?
                                          { url: facilities_management_rm3830_procurement_edit_building_path(@page_data[:model_object].id, procurement_id: params[:procurement_id]), method: :patch }
                                        else
                                          { url: facilities_management_rm3830_procurement_edit_buildings_path, method: :post }
                                        end
        end

        helper_method :step_title, :step_footer, :add_address_form_details, :valid_regions, :region_needs_resolution?, :multiple_regions?

        def redirect_if_unrecognised_step
          redirect_to facilities_management_rm3830_procurement_edit_building_path(params[:procurement_id], @page_data[:model_object]) unless RECOGNISED_STEPS.include? params[:step]
        end

        protected

        def authorize_user
          @page_data[:model_object].present? && (@page_data[:model_object].is_a? Building) ? (authorize! :manage, @page_data[:model_object]) : (authorize! :read, FacilitiesManagement)
        end
      end
    end
  end
end
