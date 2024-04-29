FactoryBot.define do
  factory :facilities_management_rm6232_admin_supplier_data_edit, class: 'FacilitiesManagement::RM6232::Admin::SupplierData::Edit' do
    user

    supplier_data do |edit|
      supplier_data = FacilitiesManagement::RM6232::Admin::SupplierData.latest_data
      edit.supplier_id = supplier_data.data.first['id']

      FacilitiesManagement::RM6232::Admin::SupplierData.latest_data
    end

    trait :with_details do
      change_type { 'details' }
      data { [{ 'attribute' => 'active', 'value' => false }] }
    end

    trait :with_service_lot_data do
      change_type { 'lot_data' }
      data { { 'lot_code' => '1a', 'attribute' => 'service_codes', 'added' => ['A.1'], 'removed' => [] } }
    end

    trait :with_region_lot_data do
      change_type { 'lot_data' }
      data { { 'lot_code' => '1a', 'attribute' => 'region_codes', 'added' => [], 'removed' => ['UKC1'] } }
    end

    trait :with_status do
      change_type { 'lot_data' }
      data { { 'lot_code' => '1a', 'attribute' => 'active', 'added' => false, 'removed' => true } }
    end
  end
end
