FactoryBot.define do
  factory :facilities_management_lift, class: FacilitiesManagement::ProcurementBuildingServiceLift do
    number_of_floors { rand(1..999) }
  end
end
