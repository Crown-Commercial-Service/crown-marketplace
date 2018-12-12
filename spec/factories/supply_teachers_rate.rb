FactoryBot.define do
  trait :direct_provision do
    lot_number { 1 }
  end

  trait :master_vendor do
    lot_number { 2 }
  end

  trait :neutral_vendor do
    lot_number { 3 }
  end

  factory :supply_teachers_rate, aliases: [:direct_provision_rate], class: SupplyTeachers::Rate do
    association :supplier, factory: :supply_teachers_supplier
    direct_provision
    job_type { 'nominated' }
    mark_up { 0.5 }
  end

  factory :supply_teachers_master_vendor_rate, parent: :supply_teachers_rate do
    master_vendor
  end

  factory :neutral_vendor_rate, parent: :supply_teachers_rate do
    neutral_vendor
  end
end
