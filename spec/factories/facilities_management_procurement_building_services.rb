require 'facilities_management/services_and_questions'
FactoryBot.define do
  factory :facilities_management_procurement_building_service, class: FacilitiesManagement::ProcurementBuildingService do
    name { Faker::Name.unique.name }
    code { 'C.1' }
    service_standard { 'A' }
  end
end
