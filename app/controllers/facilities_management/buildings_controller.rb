require 'rubygems'

module FacilitiesManagement
  class BuildingsController < FacilitiesManagement::FrameworkController
    include Buildings::BuildingsControllerDefinitions
    include Buildings::BuildingsControllerNavigation
    include FacilitiesManagement::FindAddressConcern
    include SharedBuildingsControllerMethods

    before_action :initialise_page_data
    before_action :create_new_building, only: :new
    before_action :define_all_buildings, only: :index
    before_action :build_page_data, only: %i[show edit update add_address]
    before_action :redirect_if_unrecognised_step, only: :edit
    before_action :authorize_user
    before_action :build_page_description, only: %i[index show new edit add_address]
    before_action :initialize_building_details, only: :show

    def index; end

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
                                      { url: facilities_management_building_url(@page_data[:model_object].id), method: :patch }
                                    else
                                      { url: facilities_management_buildings_path, method: :post }
                                    end
    end

    helper_method :step_title, :step_footer, :add_address_form_details, :valid_regions, :region_needs_resolution?, :multiple_regions?

    def define_all_buildings
      @page_data[:model_object] = current_user.buildings.order_by_building_name.page(params[:page])
    end

    def redirect_if_unrecognised_step
      redirect_to facilities_management_building_path(@page_data[:model_object]) unless RECOGNISED_STEPS.include? params[:step]
    end

    protected

    def authorize_user
      @page_data[:model_object].present? && (@page_data[:model_object].is_a? Building) ? (authorize! :manage, @page_data[:model_object]) : (authorize! :read, FacilitiesManagement)
    end
  end
end
