FactoryBot.define do
  factory :management_consultancy_supplier, class: ManagementConsultancy::Supplier do
    name { Faker::Company.unique.name }
    contact_name { Faker::Name.unique.name }
    contact_email { Faker::Internet.unique.email }
    telephone_number { Faker::PhoneNumber.unique.phone_number }

    after :create do |supplier|
      (2..8).each do |lot|
        create_list :management_consultancy_rate_card, 1, supplier: supplier, lot: "MCF1.#{lot}"
      end
      (1..4).each do |lot|
        create_list :management_consultancy_rate_card, 1, supplier: supplier, lot: "MCF2.#{lot}"
      end
    end
  end
end
