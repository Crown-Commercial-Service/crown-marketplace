FactoryBot.define do
  factory :facilities_management_building_defaults, class: FacilitiesManagement::Building do
    id { SecureRandom.uuid }
    updated_by { Faker::Internet.unique.email }
    association :user
  end

  factory :facilities_management_building, parent: :facilities_management_building_defaults do
    status { 'Ready' }
    gia { 1002 }
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
  end

  factory :facilities_management_building_london, parent: :facilities_management_building do
    description { 'london building' }
    region { 'London' }
    address_line_1 { '100 New Barn Street' }
    address_town { 'London' }
    address_line_2 { '' }
    address_region { 'Newham' }
    address_region_code { 'UKI3' }
    address_postcode { 'E13 8JW' }
  end
end
