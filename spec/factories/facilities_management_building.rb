FactoryBot.define do
  factory :facilities_management_building_ar_defaults, class: FacilitiesManagement::Building do
    id { SecureRandom.uuid }
    updated_by { Faker::Internet.unique.email }
    association :user
  end

  factory :facilities_management_building_ar, parent: :facilities_management_building_ar_defaults do
    gia { 1002 }
    building_name { 'non-json-building' }
    description { 'non-json description' }
    region { 'Essex' }
    building_ref { 'SS310DR' }
    building_type { 'General office - Customer Facing' }
    security_type { 'Baseline personnel security standard (BPSS)' }
    address_town { 'Southend' }
    address_county { 'Essex' }
    address_line_1 { '1 Mariners Court' }
    address_line_2 { 'Floor 2' }
    address_region { 'Essex2' }
    address_region_code { 'UKH1' }
    address_postcode { 'SS31 0DR' }
  end
end
