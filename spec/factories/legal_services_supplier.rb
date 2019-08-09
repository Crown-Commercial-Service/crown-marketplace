FactoryBot.define do
  factory :legal_services_supplier, class: LegalServices::Supplier do
    name { Faker::Company.unique.name }
    email { Faker::Internet.unique.email }
    phone_number { Faker::PhoneNumber.unique.phone_number }
    rate_cards do
      {
        'lots':
        {
          '1':
          {
            'partner':
            {
              'hourly': 40000,
              'daily': 200000,
              'monthly': 4200000
            },
            'senior':
            {
              'hourly': 21000,
              'daily': 105000,
              'monthly': 2205000
            },
            'solicitor':
            {
              'hourly': 20000,
              'daily': 100000,
              'monthly': 2100000
            },
            'junior':
            {
              'hourly': 5000,
              'daily': 40000,
              'monthly': 840000
            },
            'trainee':
            {
              'hourly': 1000,
              'daily': 5000,
              'monthly': 105000
            }
          }
        }
      }
    end
  end
end
