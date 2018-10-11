FactoryBot.define do
  factory :branch do
    postcode { 'SW1A 1AA' }
    location { Geocoding.point(latitude: 50.0, longitude: 1.0) }
    telephone_number { '020 7946 0001' }
    contact_name { 'George Henry' }
    contact_email { 'george.henry@example.com' }
  end
end
