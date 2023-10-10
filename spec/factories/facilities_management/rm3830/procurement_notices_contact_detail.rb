FactoryBot.define do
  factory :facilities_management_rm3830_procurement_notices_contact_detail, parent: :facilities_management_rm3830_procurement_contact_detail, class: 'FacilitiesManagement::RM3830::ProcurementNoticesContactDetail' do
    procurement factory: %i[facilities_management_rm3830_procurement]
  end

  factory :facilities_management_rm3830_procurement_notices_contact_detail_empty, parent: :facilities_management_rm3830_procurement_contact_detail_empty, class: 'FacilitiesManagement::RM3830::ProcurementNoticesContactDetail' do
    procurement factory: %i[facilities_management_rm3830_procurement]
  end
end
