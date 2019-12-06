FactoryBot.define do
  factory :facilities_management_procurement_building, class: FacilitiesManagement::ProcurementBuilding do
    name { Faker::Company.unique.name }
    active { true }
    procurement_building_services { build_list :facilities_management_procurement_building_service, 2 }
  end
end
