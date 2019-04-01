FactoryBot.define do
  factory :management_consultancy_rate_card, class: ManagementConsultancy::RateCard do
    association :supplier, factory: :management_consultancy_supplier
    lot { 1 }
    junior_rate_in_pence { 1000 }
    standard_rate_in_pence { 2000 }
    senior_rate_in_pence { 3000 }
    principal_rate_in_pence { 4000 }
    managing_rate_in_pence { 5000 }
    director_rate_in_pence { 6000 }
  end
end
