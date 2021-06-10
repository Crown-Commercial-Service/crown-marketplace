require 'rubygems'

module FacilitiesManagement
  class BuildingsController < FacilitiesManagement::FrameworkController
    include Buildings::BuildingsControllerNavigation
    include PageDetail::Buildings
    include FindAddressConcern
    include BuildingsConcern

    with_options only: :index do
      before_action :define_all_buildings
      before_action :authorize_user_index
      before_action :build_page_description_index
    end

    private

    def add_address_form_details
      @add_address_form_details ||= if id_present?
                                      { url: facilities_management_building_url(@page_data[:model_object].id), method: :patch }
                                    else
                                      { url: facilities_management_buildings_path(params[:framework]), method: :post }
                                    end
    end

    helper_method :step_title, :step_footer, :add_address_form_details, :valid_regions, :region_needs_resolution?, :multiple_regions?

    def define_all_buildings
      @page_data[:model_object] = current_user.buildings.order_by_building_name.page(params[:page])
    end

    def redirect_if_unrecognised_step
      redirect_to facilities_management_building_path(params[:framework], @page_data[:model_object]) unless RECOGNISED_STEPS.include? params[:step]
    end

    protected

    alias authorize_user_index authorize_user
    alias build_page_description_index build_page_description

    def authorize_user
      @page_data[:model_object].present? && (@page_data[:model_object].is_a? Building) ? (authorize! :manage, @page_data[:model_object]) : (authorize! :read, FacilitiesManagement)
    end
  end
end
