module FacilitiesManagement::Beta::BuildingsHelper
  def address?(building)
    return false if building.blank?

    building.address_town || building.address_line_1 || building.address_region
  end

  def address_in_a_line(building)
    [building.address_line_1, building.address_line_2, building.address_town, building.address_postcode].join(',')
  end
end
