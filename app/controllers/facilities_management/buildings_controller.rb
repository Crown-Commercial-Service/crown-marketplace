require 'rubygems'

module FacilitiesManagement
  class BuildingsController < FacilitiesManagement::FrameworkController
    include Buildings::BuildingsControllerDefinitions
    include Buildings::BuildingsControllerNavigation
    include Buildings::BuildingsControllerRegions
    include SharedBuildingsControllerMethods

    before_action :initialise_page_data
    before_action :create_new_building, only: :new
    before_action :define_all_buildings, only: :index
    before_action :build_page_data, only: %i[show edit update add_address]
    before_action :authorize_user
    before_action :build_page_description, only: %i[index show new edit add_address]
    before_action :initialize_building_details, only: :show

    def index; end

    def new; end

    def add_address; end

    def show; end

    def edit; end

    def create
      @page_data[:model_object] = current_user.buildings.build(building_params)
      set_postcode_data

      create_building_and_add_address && return if params[:add_address].present?

      add_new_address && return if params[:step] == 'add_address'

      if @page_data[:model_object].save(context: :new)
        redirect_to next_link(params.key?('save_and_return'), 'new')
      else
        rebuild_page_data(@page_data[:model_object])
        render :new
      end
    end

    def update
      @page_data[:model_object].assign_attributes(building_params)
      set_postcode_data

      update_address && return if params[:step] == 'add_address'

      if @page_data[:model_object].save(context: params[:step].to_sym)
        redirect_to next_link(params.key?('save_and_return'), params[:step])
      else
        rebuild_page_description 'edit'
        render :edit
      end
    end

    private

    def building_params
      params.require(:facilities_management_building).permit(:building_name, :description, :postcode, :region, :region_code, :gia, :external_area, :region, :building_type, :other_building_type, :security_type, :other_security_type, :address_town, :address_line_1, :address_line_2, :address_postcode, :address_region, :address_region_code, :postcode_entry)
    end

    def create_building_and_add_address
      rebuild_page_data(@page_data[:model_object])
      rebuild_page_description('add_address')
      render action: :add_address
    end

    def add_new_address
      if @page_data[:model_object].valid?(:add_address)
        resolve_region
        rebuild_page_data(@page_data[:model_object])
        render :new
      else
        rebuild_page_data(@page_data[:model_object])
        rebuild_page_description 'add_address'
        render :add_address
      end
    end

    def update_address
      if @page_data[:model_object].save(context: params[:step].to_sym)
        resolve_region
        redirect_to(edit_facilities_management_building_path(@page_data[:model_object].id, step: 'building_details'))
      else
        rebuild_page_description 'add_address'
        render :add_address
      end
    end

    def add_address_form_details
      @add_address_form_details ||= if id_present?
                                      { url: facilities_management_building_url(@page_data[:model_object].id), method: :patch }
                                    else
                                      { url: facilities_management_buildings_path, method: :post }
                                    end
    end

    helper_method :step_title, :step_footer, :add_address_form_details, :valid_regions, :valid_addresses, :region_needs_resolution?, :multiple_regions?, :no_regions?, :multiple_addresses?, :hide_region_section?, :hide_region_dropdown?, :hide_postcode_source?

    def initialise_page_data
      @page_data = {}
    end

    def create_new_building
      @page_data[:model_object] = Building.new(user: current_user)
    end

    def define_all_buildings
      @page_data[:model_object] = current_user.buildings.order_by_building_name.page(params[:page])
    end

    def build_page_data
      @page_data[:model_object] = Building.find(params[:id])
    end

    def initialize_building_details
      @building_details = building_details
    end

    protected

    def authorize_user
      @page_data[:model_object].present? && (@page_data[:model_object].is_a? Building) ? (authorize! :manage, @page_data[:model_object]) : (authorize! :read, FacilitiesManagement)
    end
  end
end
