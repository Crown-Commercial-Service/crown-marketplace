module SharedBuildingsControllerMethods
  extend ActiveSupport::Concern

  private

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

  def no_regions?
    valid_regions.length.zero?
  end

  def multiple_addresses?
    valid_addresses.length > 1
  end

  def valid_regions
    return @valid_regions ||= find_region_query_by_postcode(@page_data[:model_object].address_postcode) if @page_data[:model_object].address_postcode.present?

    []
  end

  def valid_addresses
    return @valid_addresses ||= find_addresses_by_postcode(@page_data[:model_object].address_postcode) if @page_data[:model_object].address_postcode.present?

    []
  end

  def set_postcode_data
    @page_data[:model_object].address_postcode = building_params[:address_postcode].upcase if building_params[:address_postcode]
  end

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

  def id_present?
    @page_data[:model_object].respond_to?(:id) && @page_data[:model_object][:id].present?
  end
end
