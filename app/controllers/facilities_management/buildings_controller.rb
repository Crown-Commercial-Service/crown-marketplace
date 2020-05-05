require 'rubygems'

module FacilitiesManagement
  class BuildingsController < FacilitiesManagement::FrameworkController
    include BuildingsControllerDefinitions
    include BuildingsControllerNavigation
    include BuildingsControllerRegions

    before_action :build_page_data, only: %i[index show new create edit update gia type security add_address]

    def index; end

    def new; end

    def add_address; end

    def show; end

    def edit; end

    def gia; end

    def type; end

    def security; end

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Style/AndOr
    def create
      @page_data[:model_object] = current_user.buildings.build(building_params)
      @page_data[:model_object].postcode_entry = ensure_postcode_is_valid(@page_data[:model_object].postcode_entry)

      if params[:add_address].present?
        @page_data[:model_object].address_postcode = ensure_postcode_is_valid(@page_data[:model_object].postcode_entry)
        rebuild_page_data(@page_data[:model_object])
        rebuild_page_description('add_address')
        render action: :add_address and return
      end

      if params[:step] == 'add_address'
        render :add_address and return if @page_data[:model_object].invalid?(:add_address)

        resolve_region
        rebuild_page_data(@page_data[:model_object])
        render :new and return
      end

      if @page_data[:model_object].save(context: :new)
        redirect_to action: next_step[0], id: @page_data[:model_object].id and return unless params.key?('save_and_return')

        redirect_to facilities_management_building_path(@page_data[:model_object].id)
      else
        rebuild_page_data(@page_data[:model_object])
        render :new
      end
    end

    def update
      @page_data[:model_object].assign_attributes(building_params)
      @page_data[:model_object].postcode_entry = ensure_postcode_is_valid(@page_data[:model_object].postcode_entry)

      if params[:add_address].present?
        @page_data[:model_object].address_postcode = ensure_postcode_is_valid(@page_data[:model_object].postcode_entry)
        rebuild_page_description 'add_address'
        render action: :add_address and return
      end

      resolve_region if params[:step] == 'add_address'

      if !@page_data[:model_object].save(context: params[:step].to_sym)
        rebuild_page_description params[:step]
        render action: params[:step]
      else
        redirect_to action: :edit and return if params[:step] == 'add_address'

        redirect_to action: next_step(params[:step])[0], id: @page_data[:model_object].id and return unless params.key?('save_and_return') || next_step(params[:step]).is_a?(Hash)

        redirect_to facilities_management_building_path(@page_data[:model_object].id)
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Style/AndOr

    def destroy; end

    private

    def building_params
      params.require(:facilities_management_building)
            .permit(
              :building_name,
              :description,
              :postcode,
              :region,
              :region_code,
              :gia,
              :region,
              :building_type,
              :other_building_type,
              :security_type,
              :other_security_type,
              :address_town,
              :address_line_1,
              :address_line_2,
              :address_postcode,
              :address_region,
              :address_region_code,
              :postcode_entry
            )
    end

    def add_address_form_details
      @add_address_form_details ||= if id_present?
                                      { url: facilities_management_building_url(@page_data[:model_object].id), method: :patch }
                                    else
                                      { url: facilities_management_buildings_path, method: :post }
                                    end
    end

    def region_needs_resolution?
      @page_data[:model_object].address_region_code.blank?
    end

    def hide_region_section?
      return false if @page_data[:model_object].address_region.present?

      true if @page_data[:model_object].address_region.blank? && @page_data[:model_object].address_postcode.blank?
    end

    def hide_region_dropdown?
      return true if @page_data[:model_object].address_region.present?

      false
    end

    def hide_postcode_source?
      @page_data[:model_object].address_line_1.present? || @page_data[:model_object].errors.details.dig(:address, 0)&.dig(:error) == :not_selected
    end

    def multiple_regions?
      valid_regions.length > 1
    end

    def multiple_addresses?
      valid_addresses.length > 1
    end

    def valid_regions
      return @valid_regions ||= find_region_query_by_postcode(@page_data[:model_object].address_postcode) if @page_data[:model_object].address_postcode.present?

      []
    end

    def valid_addresses
      return @valid_addresses ||= find_addresses_by_postcode(@page_data[:model_object].postcode_entry) if @page_data[:model_object].postcode_entry.present?

      []
    end

    helper_method :step_title, :step_footer, :add_address_form_details, :valid_regions, :valid_addresses, :region_needs_resolution?,
                  :multiple_regions?, :multiple_addresses?, :hide_region_section?, :hide_region_dropdown?, :hide_postcode_source?

    def resolve_region
      return if @page_data[:model_object].blank?

      return if valid_regions.length > 1 || valid_regions.empty?

      @page_data[:model_object].address_region = valid_regions[0][:region]
      @page_data[:model_object].address_region_code = valid_regions[0][:code]
    end

    def rebuild_page_data(building)
      @building_page_details    = @page_description = @page_definitions = nil
      @page_data[:model_object] = building

      build_page_description
    end

    def build_page_data
      @page_data                = {}
      @page_data[:model_object] = Building.find(params[:id]) if params[:id]
      @page_data[:model_object] = current_user.buildings.order('lower(building_name)') if action_name == 'index'
      @page_data[:model_object] = Building.new if @page_data[:model_object].nil?

      build_page_description
    end

    def id_present?
      @page_data[:model_object].respond_to?(:id) && @page_data[:model_object][:id].present?
    end
  end
end
