FactoryBot.define do
  factory :facilities_management_building, class: FacilitiesManagement::Buildings do
    id { "fc77fb4e-5c95-42ac-8cfa-1fe8a45ab7bf"}
    user_id { create(:user).id }
    building_json  {
      {"id"=>"fc77fb4e-5c95-42ac-8cfa-1fe8a45ab7bf",
       "gia"=>"1002",
       "name"=>"asa",
       "region"=>"London",
       "address"=>
         {"fm-address-town"=>" London",
          "fm-address-county"=>" Newham",
          "fm-address-line-1"=>"102 New Barn Street",
          "fm-address-line-2"=>" London",
          "fm-address-region"=>"Inner London - East",
          "fm-address-postcode"=>"E13 8JW"},
       "description"=>"",
       "building-ref"=>" E131B8JW",
       "building-type"=>"General office - Customer Facing",
       "security-type"=>"Baseline personnel security standard (BPSS)"}
    }
    status {"Ready"}
    updated_by { Faker::Internet.unique.email }
  end
end