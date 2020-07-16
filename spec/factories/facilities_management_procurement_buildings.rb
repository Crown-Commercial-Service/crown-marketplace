FactoryBot.define do
  factory :facilities_management_procurement_building, class: FacilitiesManagement::ProcurementBuilding do
    active { true }
    procurement_building_services { build_list :facilities_management_procurement_building_service, 2 }
    building { create :facilities_management_building }
    gia { 1002 }
    external_area { 4596 }
    building_name { 'asa' }
    description { 'non-json description' }
    region { 'Essex' }
    building_type { 'General office - Customer Facing' }
    security_type { 'Baseline personnel security standard (BPSS)' }
    address_town { 'Southend-On-Sea' }
    address_line_1 { '10 Mariners Court' }
    address_line_2 { 'Floor 2' }
    address_region { 'Essex' }
    address_region_code { 'UKH1' }
    address_postcode { 'SS31 0DR' }
    building_json { building.building_json }
  end

  factory :facilities_management_procurement_building_london, parent: :facilities_management_procurement_building do
    building { create :facilities_management_building_london }
  end
  factory :facilities_management_procurement_building_no_services, parent: :facilities_management_procurement_building do
    procurement_building_services { [] }
    building { create(:facilities_management_building) }
    building_json { building.building_json }
  end
  factory :facilities_management_procurement_building_for_further_competition, class: FacilitiesManagement::ProcurementBuilding do
    active { true }
    procurement_building_services { build_list :facilities_management_procurement_building_service, 2 }
    building { create :facilities_management_building_london }
    building_json { building.building_json }
  end
  factory :facilities_management_procurement_building_for_further_competition_with_gia, parent: :facilities_management_procurement_building do
    building { create :facilities_management_building_london }
  end
end
