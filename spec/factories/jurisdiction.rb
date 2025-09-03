FactoryBot.define do
  factory :jurisdiction, class: 'Jurisdiction' do
    initialize_with do
      country_code = Faker::Alphanumeric.unique.alphanumeric(number: 2).upcase

      jurisdiction = Jurisdiction.find_by(id: country_code)

      if jurisdiction.present?
        jurisdiction
      else
        country_name = Faker::Alphanumeric.unique.alphanumeric(number: 10)

        new(id: country_code, name: country_name, mapping_name: country_name)
      end
    end
  end
end
