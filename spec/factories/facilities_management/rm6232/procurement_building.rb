FactoryBot.define do
  factory :facilities_management_rm6232_procurement_building_no_services, class: 'FacilitiesManagement::RM6232::ProcurementBuilding' do
    active { true }
    building { create(:facilities_management_building) }
  end

  factory :facilities_management_rm6232_procurement_building, parent: :facilities_management_rm6232_procurement_building_no_services do
    service_codes { ['E.1', 'E.2'] }
  end

  factory :facilities_management_rm6232_procurement_building_with_frozen_data, parent: :facilities_management_rm6232_procurement_building do
    frozen_building_data do |procurement_building|
      procurement_building.frozen_building_data = procurement_building.building.attributes.slice(*%w[building_name description address_town address_line_1 address_line_2 address_postcode address_region address_region_code gia external_area building_type other_building_type security_type other_security_type])
    end
  end
end
