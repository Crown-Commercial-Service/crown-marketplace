require 'facilities_management/services_and_questions'
FactoryBot.define do
  factory :facilities_management_procurement_building_service, class: FacilitiesManagement::ProcurementBuildingService do
    name { Faker::Name.unique.name }
    code { 'C.1' }
    service_standard { 'A' }
  end

  factory :facilities_management_procurement_building_service_with_service_hours, parent: :facilities_management_procurement_building_service do
    code { 'H.4' }
    service_hours do
      {
        monday:
        {
          service_choice: 'hourly',
          start_hour: 9,
          start_minute: 0,
          start_ampm: 'AM',
          end_hour: 1,
          end_minute: 0,
          end_ampm: 'PM',
          uom: 4.0
        },
        tuesday:
        {
          service_choice: 'not_required',
          start_hour: 1,
          start_minute: 0,
          start_ampm: 'AM',
          end_hour: 1,
          end_minute: 0,
          end_ampm: 'AM',
          uom: 0.0
        },
        wednesday:
        {
          service_choice: 'not_required',
          start_hour: 1,
          start_minute: 0,
          start_ampm: 'AM',
          end_hour: 1,
          end_minute: 0,
          end_ampm: 'AM',
          uom: 0.0
        },
        thursday:
        {
          service_choice: 'not_required',
          start_hour: 1,
          start_minute: 0,
          start_ampm: 'AM',
          end_hour: 1,
          end_minute: 0,
          end_ampm: 'AM',
          uom: 0.0
        },
        friday:
        {
          service_choice: 'not_required',
          start_hour: 1,
          start_minute: 0,
          start_ampm: 'AM',
          end_hour: 1,
          end_minute: 0,
          end_ampm: 'AM',
          uom: 0.0
        },
        saturday:
        {
          service_choice: 'not_required',
          start_hour: 1,
          start_minute: 0,
          start_ampm: 'AM',
          end_hour: 1,
          end_minute: 0,
          end_ampm: 'AM',
          uom: 0.0
        },
        sunday:
        {
          service_choice: 'not_required',
          start_hour: 1,
          start_minute: 0,
          start_ampm: 'AM',
          end_hour: 1,
          end_minute: 0,
          end_ampm: 'AM',
          uom: 0.0
        }
      }
    end
  end
end
