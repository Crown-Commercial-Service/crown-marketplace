require 'facilities_management/services_and_questions'
FactoryBot.define do
  factory :facilities_management_procurement_building_service, class: 'FacilitiesManagement::ProcurementBuildingService' do
    name { Faker::Name.unique.name }
    code { 'C.1' }
    service_standard { 'A' }
  end

  factory :facilities_management_procurement_building_service_with_service_hours, parent: :facilities_management_procurement_building_service do
    code { 'H.4' }
    service_hours { 208 }
    detail_of_requirement { 'Details of the requirement' }
  end

  factory :facilities_management_procurement_building_service_with_lifts, parent: :facilities_management_procurement_building_service do
    code { 'C.5' }
    lifts { build_list :facilities_management_lift, 5 }
  end
end
