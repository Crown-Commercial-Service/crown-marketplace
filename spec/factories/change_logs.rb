FactoryBot.define do
  factory :change_log, class: 'ChangeLog' do
    change_type { 'upload_supplier_data' }

    user { association(:user) }

    after(:build) do |change_log, evaluator|
      change_log.framework ||= evaluator.framework || create(:framework)
    end

    trait :with_upload_supplier_data_change_type do
      change_type { 'upload_supplier_data' }
      change_data { { 'admin_upload_id' => SecureRandom.uuid, 'supplier_data' => {} } }
    end

    trait :with_update_supplier_information_change_type do
      change_type { 'update_supplier_information' }
      change_data { { 'id' => SecureRandom.uuid, 'supplier_name' => Faker::Name.unique.name, 'before' => { 'name' => Faker::Name.unique.name }, 'after' => { 'name' => Faker::Name.unique.name } } }
    end

    trait :with_update_supplier_contact_information_change_type do
      change_type { 'update_supplier_contact_information' }
      change_data { { 'id' => SecureRandom.uuid, 'supplier_name' => Faker::Name.unique.name, 'before' => { 'name' => Faker::Name.unique.name, 'email' => Faker::Internet.unique.email, 'telephone_number' => Faker::PhoneNumber.unique.cell_phone_in_e164[1..], 'website' => Faker::Internet.unique.url }, 'after' => { 'name' => Faker::Name.unique.name, 'email' => Faker::Internet.unique.email, 'telephone_number' => Faker::PhoneNumber.unique.cell_phone_in_e164[1..], 'website' => Faker::Internet.unique.url } } }
    end

    trait :with_update_supplier_additional_information_change_type do
      change_type { 'update_supplier_additional_information' }
      change_data { { 'id' => SecureRandom.uuid, 'supplier_name' => Faker::Name.unique.name, 'before' => { 'additional_details' => { 'managed_service_provider_name' => Faker::Name.unique.name, 'managed_service_provider_email' => Faker::Internet.unique.email, 'managed_service_provider_telephone' => Faker::PhoneNumber.unique.cell_phone_in_e164[1..] } }, 'after' => { 'additional_details' => { 'managed_service_provider_name' => Faker::Name.unique.name, 'managed_service_provider_email' => Faker::Internet.unique.email, 'managed_service_provider_telephone' => Faker::PhoneNumber.unique.cell_phone_in_e164[1..] } } } }
    end

    trait :with_update_supplier_framework_lot_status_change_type do
      change_type { 'update_supplier_framework_lot_status' }
      change_data { { 'id' => SecureRandom.uuid, 'supplier_name' => Faker::Name.unique.name, 'lot_id' => 'RM6360.1', 'before' => { 'enabled' => true }, 'after' => { 'enabled' => false } } }
    end

    trait :with_update_supplier_framework_lot_services_change_type do
      change_type { 'update_supplier_framework_lot_services' }
      change_data { { 'id' => SecureRandom.uuid, 'supplier_name' => Faker::Name.unique.name, 'lot_id' => 'RM6360.1', 'added' => ['RM6360.1.1', 'RM6360.1.2', 'RM6360.1.3'], 'removed' => ['RM6360.1.4', 'RM6360.1.5', 'RM6360.1.6'] } }
    end

    trait :with_update_supplier_framework_lot_jurisdictions_change_type do
      change_type { 'update_supplier_framework_lot_jurisdictions' }
      change_data { { 'id' => SecureRandom.uuid, 'supplier_name' => Faker::Name.unique.name, 'lot_id' => 'RM6360.1', 'added' => ['BR', 'CN', 'JP'], 'removed' => ['HK', 'KH', 'ME'] } }
    end

    trait :with_update_supplier_framework_lot_rates_change_type do
      change_type { 'update_supplier_framework_lot_rates' }
      change_data { { 'id' => SecureRandom.uuid, 'supplier_name' => Faker::Name.unique.name, 'lot_id' => 'RM6376.1', 'jurisdiction_id' => 'RM6376.GB', 'rates' => [{ 'before' => 15000, 'id' => SecureRandom.uuid, 'position_id' => 'RM6376.1.1' }, { 'before' => 18000, 'after' => 17999, 'id' => SecureRandom.uuid, 'position_id' => 'RM6376.1.2' }, { 'after' => 20000, 'id' => SecureRandom.uuid, 'position_id' => 'RM6376.1.3' }] } }
    end

    trait :with_add_rates_for_supplier_framework_lot_jurisdiction_change_type do
      change_type { 'add_rates_for_supplier_framework_lot_jurisdiction' }
      change_data { { 'id' => SecureRandom.uuid, 'supplier_name' => Faker::Name.unique.name, 'lot_id' => 'RM6376.1', 'jurisdiction_id' => 'RM6376.GB', 'rates' => [{ 'after' => 15000, 'id' => SecureRandom.uuid, 'position_id' => 'RM6376.1.1' }, { 'after' => 18000, 'id' => SecureRandom.uuid, 'position_id' => 'RM6376.1.2' }, { 'after' => 20000, 'id' => SecureRandom.uuid, 'position_id' => 'RM6376.1.3' }] } }
    end

    trait :with_remove_rates_for_supplier_framework_lot_jurisdiction_change_type do
      change_type { 'remove_rates_for_supplier_framework_lot_jurisdiction' }
      change_data { { 'id' => SecureRandom.uuid, 'supplier_name' => Faker::Name.unique.name, 'lot_id' => 'RM6376.1', 'jurisdiction_id' => 'RM6376.GB', 'rates' => [{ 'before' => 15000, 'id' => SecureRandom.uuid, 'position_id' => 'RM6376.1.1' }, { 'before' => 18000, 'id' => SecureRandom.uuid, 'position_id' => 'RM6376.1.2' }, { 'before' => 20000, 'id' => SecureRandom.uuid, 'position_id' => 'RM6376.1.3' }] } }
    end

    trait :with_update_supplier_framework_lot_branch_change_type do
      change_type { 'update_supplier_framework_lot_branch' }
      change_data { { 'id' => SecureRandom.uuid, 'supplier_name' => Faker::Name.unique.name, 'lot_id' => 'RM6376.1', 'before' => { 'address_line_1' => 'This' }, 'after' => { 'address_line_2' => 'that' } } }
    end
  end
end
