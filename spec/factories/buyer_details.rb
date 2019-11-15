FactoryBot.define do
  factory :buyer_detail, class: FacilitiesManagement::BuyerDetail do
    full_name { 'MyString' }
    job_title { 'MyString' }
    telephone_number { 'MyString' }
    organisation_name { 'MyString' }
    organisation_address_line_1 { 'MyString' }
    organisation_address_line_2 { 'MyString' }
    organisation_address_town { 'MyString' }
    organisation_address_county { 'MyString' }
    organisation_address_postcode { 'MyString' }
    central_government { true }
  end
end
