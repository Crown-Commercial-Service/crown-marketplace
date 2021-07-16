FactoryBot.define do
  factory :facilities_management_rm3830_procurement_supplier, class: 'FacilitiesManagement::RM3830::ProcurementSupplier' do
    direct_award_value { rand(50000..100000) }
    association :procurement, factory: :facilities_management_rm3830_procurement
    association :supplier, factory: :facilities_management_rm3830_supplier_detail
  end

  factory :facilities_management_rm3830_procurement_supplier_da, parent: :facilities_management_rm3830_procurement_supplier do
    association :procurement, factory: :facilities_management_rm3830_procurement_direct_award
  end

  factory :facilities_management_rm3830_procurement_supplier_da_with_supplier, parent: :facilities_management_rm3830_procurement_supplier_da do
    supplier_id { create(:facilities_management_rm3830_supplier_detail).id }
  end

  factory :facilities_management_rm3830_procurement_supplier_fc, parent: :facilities_management_rm3830_procurement_supplier do
    association :procurement, factory: :facilities_management_rm3830_procurement_further_competition
  end
end
