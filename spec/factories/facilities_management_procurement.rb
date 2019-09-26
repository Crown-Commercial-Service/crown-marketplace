FactoryBot.define do
  factory :facilities_management_procurement, class: FacilitiesManagement::Procurement do
    name { Faker::Company.unique.name }
    association :user
  end
end
