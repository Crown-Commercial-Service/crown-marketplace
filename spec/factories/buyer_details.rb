FactoryBot.define do
  factory :buyer_detail, class: 'FacilitiesManagement::BuyerDetail' do
    full_name { 'MyString' }
    job_title { 'MyString' }
    telephone_number { '07500404040' }
    organisation_name { 'MyString' }
    organisation_address_line_1 { 'MyString' }
    organisation_address_line_2 { 'MyString' }
    organisation_address_town { 'MyString' }
    organisation_address_county { 'MyString' }
    organisation_address_postcode { 'SW1W 9SZ' }
    central_government { true }
    sector { 'defence_and_security' }
    contact_opt_in { true }
  end
end
