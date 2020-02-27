FactoryBot.define do
  factory :facilities_management_building, class: FacilitiesManagement::Buildings do
    id { SecureRandom.uuid }
    user_id { create(:user).id }
    status { 'Ready' }
    updated_by { Faker::Internet.unique.email }
    building_json do
      { 'id' => id,
        'gia' => '1002',
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

  factory :facilities_management_building_london, parent: :facilities_management_building do
    building_json do
      { 'id' => id,
        'gia' => '1002',
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
