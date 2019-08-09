FactoryBot.define do
  factory :legal_services_service_offering, class: LegalServices::ServiceOffering do
    association :supplier, factory: :legal_services_supplier
    lot_number { '1' }
    service_code { 'WPSLS.1.1' }
  end
end
