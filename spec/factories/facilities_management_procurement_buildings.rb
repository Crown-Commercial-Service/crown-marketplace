FactoryBot.define do
  factory :facilities_management_procurement_building, class: FacilitiesManagement::ProcurementBuilding do
    name { Faker::Company.unique.name }
  end
end
