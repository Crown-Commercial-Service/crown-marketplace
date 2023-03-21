FactoryBot.define do
  factory :facilities_management_rm3830_procurement_building_av_default, class: 'FacilitiesManagement::RM3830::ProcurementBuilding' do
    active { true }
    building { create(:facilities_management_building) }
  end

  factory :facilities_management_rm3830_procurement_building_av_normal_building, parent: :facilities_management_rm3830_procurement_building_av_default do
    building_name { 'Normal building' }
    gia { 63200 }
    external_area { 600 }
    address_line_1 { '10 Kenton Avenue' }
    address_town { 'Manchester' }
    address_postcode { 'M18 7GQ' }
    address_region { 'Greater Manchester' }
    address_region_code { 'UKD3' }
    building_type { 'General office - Non Customer Facing' }
    security_type { 'No specific requirement' }
  end

  factory :facilities_management_rm3830_procurement_building_av_london_building, parent: :facilities_management_rm3830_procurement_building_av_default do
    building_name { 'London building' }
    gia { 63200 }
    external_area { 600 }
    address_line_1 { '2 Marylebone Road' }
    address_town { 'London' }
    address_postcode { 'NW1 4DF' }
    address_region { 'Inner London - West' }
    address_region_code { 'UKI3' }
    building_type { 'General office - Customer Facing' }
    security_type { 'Baseline personnel security standard (BPSS)' }
  end
end
