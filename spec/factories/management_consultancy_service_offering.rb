FactoryBot.define do
  factory :management_consultancy_service_offering, class: ManagementConsultancy::ServiceOffering do
    association :supplier, factory: :management_consultancy_supplier
    lot_number { '1' }
    service_code { '1.1' }
  end
end
