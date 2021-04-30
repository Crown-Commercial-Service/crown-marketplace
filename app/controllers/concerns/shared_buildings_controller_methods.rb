# rubocop:disable Metrics/ModuleLength
module SharedBuildingsControllerMethods
  extend ActiveSupport::Concern

  def create_building_action
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

  def update_building_action
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

  def create_building_and_add_address
    rebuild_page_data(@page_data[:model_object])
    rebuild_page_description('add_address')
    render action: :add_address
  end

  def add_new_address
    if @page_data[:model_object].valid?(:add_address)
      resolve_region(false)
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
      resolve_region(true)
      redirect_to update_address_link
    else
      rebuild_page_description 'add_address'
      render :add_address
    end
  end

  def building_params
    params.require(:facilities_management_building).permit(
      :building_name,
      :description,
      :gia,
      :external_area,
      :building_type,
      :other_building_type,
      :security_type,
      :other_security_type,
      :address_line_1,
      :address_line_2,
      :address_town,
      :address_postcode,
      :address_region,
      :address_region_code
    )
  end

  def initialise_page_data
    @page_data = {}
  end

  def create_new_building
    @page_data[:model_object] = current_user.buildings.build
  end

  def build_page_data
    @page_data[:model_object] = FacilitiesManagement::Building.find(params[:id])
  end

  def region_needs_resolution?
    @page_data[:model_object].address_region_code.blank?
  end

  def initialize_building_details
    @building_details = building_details
  end

  def multiple_regions?
    valid_regions.length > 1
  end

  def valid_regions
    return @valid_regions ||= find_region_query_by_postcode(@page_data[:model_object].address_postcode) if @page_data[:model_object].address_postcode.present?

    []
  end

  def set_postcode_data
    @page_data[:model_object].address_postcode = building_params[:address_postcode].upcase if building_params[:address_postcode]
  end

  def resolve_region(save_region)
    return if @page_data[:model_object].blank?

    return if valid_regions.length > 1 || valid_regions.empty?

    @page_data[:model_object].address_region = valid_regions[0][:region]
    @page_data[:model_object].address_region_code = valid_regions[0][:code]
    @page_data[:model_object].save if save_region
  end

  def rebuild_page_data(building)
    @building_page_details    = @page_description = @page_definitions = nil
    @page_data[:model_object] = building

    build_page_description
  end

  def id_present?
    @page_data[:model_object].respond_to?(:id) && @page_data[:model_object][:id].present?
  end

  RECOGNISED_STEPS = %w[building_details gia type security].freeze
end
# rubocop:enable Metrics/ModuleLength
