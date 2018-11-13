FactoryBot.define do
  factory :management_consultancy_service_offering, class: ManagementConsultancy::ServiceOffering do
    association :supplier, factory: :management_consultancy_supplier
    lot_number { ManagementConsultancy::Lot.all.map(&:number).sample }
    service_code { '1.1' }
  end
end
