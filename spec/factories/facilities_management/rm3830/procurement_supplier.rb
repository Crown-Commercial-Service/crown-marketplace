FactoryBot.define do
  factory :facilities_management_rm3830_procurement_supplier, class: 'FacilitiesManagement::RM3830::ProcurementSupplier' do
    direct_award_value { rand(50000..100000) }
    procurement factory: %i[facilities_management_rm3830_procurement]
    supplier factory: %i[facilities_management_rm3830_supplier_detail]
  end

  factory :facilities_management_rm3830_procurement_supplier_da, parent: :facilities_management_rm3830_procurement_supplier do
    procurement factory: %i[facilities_management_rm3830_procurement_direct_award]
  end

  factory :facilities_management_rm3830_procurement_supplier_da_with_supplier, parent: :facilities_management_rm3830_procurement_supplier_da do
    supplier_id { create(:facilities_management_rm3830_supplier_detail).id }
  end

  factory :facilities_management_rm3830_procurement_supplier_fc, parent: :facilities_management_rm3830_procurement_supplier do
    procurement factory: %i[facilities_management_rm3830_procurement_further_competition]
  end

  factory :facilities_management_rm3830_procurement_supplier_with_contract_documents, parent: :facilities_management_rm3830_procurement_supplier do
    contract_documents_zip { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'test_zip.zip'), 'application/zip') }
  end
end
