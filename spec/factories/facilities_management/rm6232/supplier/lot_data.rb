FactoryBot.define do
  factory :facilities_management_rm6232_supplier_lot_data, class: 'FacilitiesManagement::RM6232::Supplier::LotData' do
    id { SecureRandom.uuid }
    lot_code { '1a' }
    service_codes { %w[E.16 H.6 P.11] }
    region_codes { %w[UKC1 UKD1 UKE1] }

    trait :with_supplier do
      supplier { build(:facilities_management_rm6232_supplier) }
    end
  end
end
