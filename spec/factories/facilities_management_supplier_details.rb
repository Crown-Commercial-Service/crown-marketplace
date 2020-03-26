FactoryBot.define do
  factory :facilities_management_supplier_detail, class: FacilitiesManagement::SupplierDetail do
    name { Faker::Name.unique.name }
    contact_name { Faker::Name.unique.name }
    contact_email { Faker::Internet.unique.email }
  end
end
