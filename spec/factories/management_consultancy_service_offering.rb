FactoryBot.define do
  factory :management_consultancy_service_offering, class: ManagementConsultancy::ServiceOffering do
    association :supplier, factory: :management_consultancy_supplier
    lot_number { 'MCF1.2' }
    service_code { 'MCF1.2.1' }
  end
end
