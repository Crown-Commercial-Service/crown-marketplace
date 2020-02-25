FactoryBot.define do
  factory :facilities_management_procurement_building, class: FacilitiesManagement::ProcurementBuilding do
    name { Faker::Company.unique.name }
    active { true }
    procurement_building_services { build_list :facilities_management_procurement_building_service, 2 }
  end
  factory :facilities_management_procurement_building_no_services, parent: :facilities_management_procurement_building do
    building_id { create(:facilities_management_building).id }
    procurement_building_services { [] }
  end
end
