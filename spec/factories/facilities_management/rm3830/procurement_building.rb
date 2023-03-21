FactoryBot.define do
  factory :facilities_management_rm3830_procurement_building_no_services, class: 'FacilitiesManagement::RM3830::ProcurementBuilding' do
    active { true }
    building { create(:facilities_management_building) }
    gia { 1002 }
    external_area { 4596 }
    building_name { 'asa' }
    description { 'non-json description' }
    building_type { 'General office - Customer Facing' }
    security_type { 'Baseline personnel security standard (BPSS)' }
    address_town { 'Southend-On-Sea' }
    address_line_1 { '17 Sailors road' }
    address_line_2 { 'Floor 2' }
    address_region { 'Essex' }
    address_region_code { 'UKH1' }
    address_postcode { 'SS84 6VF' }
  end

  factory :facilities_management_rm3830_procurement_building, parent: :facilities_management_rm3830_procurement_building_no_services do
    procurement_building_services { build_list(:facilities_management_rm3830_procurement_building_service, 2) }
  end

  factory :facilities_management_rm3830_procurement_building_london, parent: :facilities_management_rm3830_procurement_building do
    building { create(:facilities_management_building_london) }
    description { 'london building' }
    address_line_1 { '100 New Barn Street' }
    address_town { 'London' }
    address_line_2 { '' }
    address_region { 'Newham' }
    address_region_code { 'UKI3' }
    address_postcode { 'E13 8JW' }
  end

  factory :facilities_management_rm3830_procurement_building_for_further_competition, parent: :facilities_management_rm3830_procurement_building_london do
    procurement_building_services { build_list(:facilities_management_rm3830_procurement_building_service, 2) }
  end

  factory :facilities_management_rm3830_procurement_building_for_further_competition_with_gia, parent: :facilities_management_rm3830_procurement_building_london do
    building { create(:facilities_management_building_london) }
  end

  factory :facilities_management_rm3830_procurement_building_with_lifts, parent: :facilities_management_rm3830_procurement_building_no_services do
    procurement_building_services { build_list(:facilities_management_rm3830_procurement_building_service_with_lifts, 1) }
  end
end
