FactoryBot.define do
  factory :facilities_management_rm3830_lift, class: 'FacilitiesManagement::RM3830::ProcurementBuildingServiceLift' do
    number_of_floors { rand(1..999) }
  end
end
