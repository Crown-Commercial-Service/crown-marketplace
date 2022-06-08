FactoryBot.define do
  factory :facilities_management_rm6232_procurement_building_no_services, class: 'FacilitiesManagement::RM6232::ProcurementBuilding' do
    active { true }
    building { create :facilities_management_building }
  end

  factory :facilities_management_rm6232_procurement_building, parent: :facilities_management_rm6232_procurement_building_no_services do
    service_codes { ['E.1', 'E.2'] }
  end
end
