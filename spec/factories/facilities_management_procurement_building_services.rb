FactoryBot.define do
  factory :facilities_management_procurement_building_service, class: FacilitiesManagement::ProcurementBuildingService do
    name { Faker::Company.unique.name }
  end
end
