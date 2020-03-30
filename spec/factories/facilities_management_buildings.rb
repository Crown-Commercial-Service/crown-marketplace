FactoryBot.define do
  factory :facilities_management_buildings_ar_defaults, class: FacilitiesManagement::Buildings do
    id { SecureRandom.uuid }
    user_id { create(:user).id }
    updated_by { Faker::Internet.unique.email }
  end

  factory :facilities_management_buildings_ar, parent: :facilities_management_buildings_ar_defaults do
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

  factory :facilities_management_buildings, class: FacilitiesManagement::Buildings do
    id { SecureRandom.uuid }
    user_id { create(:user).id }
    status { 'Ready' }
    updated_by { Faker::Internet.unique.email }
    building_json do
      { 'id' => id,
        'gia' => 1002,
        'name' => 'asa',
        'region' => 'Essex',
        'address' =>
          { 'fm-address-town' => 'Southend-On-Sea',
            'fm-address-line-1' => '10 Mariners Court',
            'fm-address-line-2' => '',
            'fm-address-region' => 'Essex',
            'fm-address-region-code' => 'UKH1',
            'fm-address-postcode' => 'SS31 0DR' },
        'description' => '',
        'building-ref' => ' SS310DR',
        'building-type' => 'General office - Customer Facing',
        'security-type' => 'Baseline personnel security standard (BPSS)' }
    end
  end

  factory :facilities_management_buildings_london, parent: :facilities_management_buildings do
    building_json do
      { 'id' => id,
        'gia' => 1002,
        'name' => 'asa',
        'region' => 'London',
        'address' =>
          { 'fm-address-town' => 'London',
            'fm-address-line-1' => '100 New Barn Street',
            'fm-address-line-2' => '',
            'fm-address-region' => 'Newham',
            'fm-address-region-code' => 'UKI3',
            'fm-address-postcode' => 'E13 8JW' },
        'description' => '',
        'building-ref' => ' E138JW',
        'building-type' => 'General office - Customer Facing',
        'security-type' => 'Baseline personnel security standard (BPSS)' }
    end
  end
end
