FactoryBot.define do
  factory :facilities_management_building_defaults, class: 'FacilitiesManagement::Building' do
    updated_by { Faker::Internet.unique.email }
    user
  end

  factory :facilities_management_building, parent: :facilities_management_building_defaults do
    status { 'Ready' }
    gia { 1002 }
    external_area { 4596 }
    building_name { "#{Faker::Company.unique.name[0..40]} building" }
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

  factory :facilities_management_building_london, parent: :facilities_management_building do
    description { 'london building' }
    address_line_1 { '100 New Barn Street' }
    address_town { 'London' }
    address_line_2 { '' }
    address_region { 'Newham' }
    address_region_code { 'UKI3' }
    address_postcode { 'E13 8JW' }
  end
end
