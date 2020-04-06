module FacilitiesManagement::Beta::BuildingsHelper
  def address?(building)
    return false if building.blank?

    building.address_town || building.address_line_1 || building.address_region
  end

  def address_in_a_line(building)
    [building.address_line_1, building.address_line_2, building.address_town, building.address_postcode].join(',')
  end

  def other_margin_if_security_has_other_error(building)
    building.errors.key?(:other_security_type) ? { style: 'margin-left: 1em' } : {}
  end

  def open_state_of_building_details(building)
    if FacilitiesManagement::Building::BUILDING_TYPES.drop(2).include?(building[:building_type]) || building.errors.key?(:other_building_type)
      'true'
    else
      'false'
    end
  end
end
