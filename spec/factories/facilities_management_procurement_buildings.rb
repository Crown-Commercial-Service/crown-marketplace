FactoryBot.define do
  factory :facilities_management_procurement_building, class: FacilitiesManagement::ProcurementBuilding do
    name { Faker::Name.unique.name }
    active { true }
    procurement_building_services { build_list :facilities_management_procurement_building_service, 2 }
    building { create :facilities_management_building }
    gia { 1002 }
  end
  factory :facilities_management_procurement_building_london, parent: :facilities_management_procurement_building do
    building { create :facilities_management_building_london }
  end
  factory :facilities_management_procurement_building_no_services, parent: :facilities_management_procurement_building do
    procurement_building_services { [] }
    building { create(:facilities_management_building) }
  end
  factory :facilities_management_procurement_building_for_further_competition, class: FacilitiesManagement::ProcurementBuilding do
    name { Faker::Name.unique.name }
    active { true }
    procurement_building_services { build_list :facilities_management_procurement_building_service, 2 }
    building { create :facilities_management_building_london }
  end
end
