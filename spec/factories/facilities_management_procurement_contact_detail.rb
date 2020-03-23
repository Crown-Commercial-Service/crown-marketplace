FactoryBot.define do
  factory :facilities_management_procurement_contact_detail, class: FacilitiesManagement::ProcurementContactDetail do
    name { Faker::Name.name[1..50] }
    job_title { Faker::Job.title }
    email { Faker::Internet.email }
    organisation_address_line_1 { Faker::Address.street_address }
    organisation_address_town { Faker::Address.city }
    organisation_address_postcode { Faker::Address.postcode }
  end
end
