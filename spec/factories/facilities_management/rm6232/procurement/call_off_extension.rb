FactoryBot.define do
  factory :facilities_management_rm6232_procurement_call_off_extension, class: 'FacilitiesManagement::RM6232::Procurement::CallOffExtension' do
    extension { 0 }
    years { 1 }
    months { 1 }
    extension_required { 'true' }
    procurement factory: %i[facilities_management_rm6232_procurement_entering_requirements]
  end
end
