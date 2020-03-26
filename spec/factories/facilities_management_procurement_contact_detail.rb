FactoryBot.define do
  factory :facilities_management_procurement_contact_detail, class: FacilitiesManagement::ProcurementContactDetail do
    name { 'MyString' }
    job_title { 'MyString' }
    email { 'person@ccs.com' }
    organisation_address_line_1 { 'MyString' }
    organisation_address_town { 'MyString' }
    organisation_address_postcode { 'MyString' }
  end
end
