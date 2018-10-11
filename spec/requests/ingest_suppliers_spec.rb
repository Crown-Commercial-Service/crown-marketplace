require 'rails_helper'

RSpec.describe 'Ingest suppliers', type: :request do
  describe 'POST /uploads' do
    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
    let(:suppliers) do
      [
        {
          'supplier_name' => Faker::Company.unique.name,
          'branches' => [
            {
              'postcode' => Faker::Address.unique.postcode,
              'lat' => Faker::Address.unique.latitude,
              'lon' => Faker::Address.unique.longitude,
              'telephone' => Faker::PhoneNumber.unique.phone_number,
              'contacts' => [
                {
                  'name' => Faker::Name.unique.name,
                  'email' => Faker::Internet.unique.email
                }
              ]
            },
            {
              'postcode' => Faker::Address.unique.postcode,
              'lat' => Faker::Address.unique.latitude,
              'lon' => Faker::Address.unique.longitude,
              'telephone' => Faker::PhoneNumber.unique.phone_number,
              'contacts' => [
                {
                  'name' => Faker::Name.unique.name,
                  'email' => Faker::Internet.unique.email
                }
              ]
            }
          ]
        },
        {
          'supplier_name' => Faker::Company.unique.name,
          'branches' => [
            {
              'postcode' => Faker::Address.unique.postcode,
              'lat' => Faker::Address.unique.latitude,
              'lon' => Faker::Address.unique.longitude,
              'telephone' => Faker::PhoneNumber.unique.phone_number,
              'contacts' => [
                {
                  'name' => Faker::Name.unique.name,
                  'email' => Faker::Internet.unique.email
                }
              ]
            }
          ]
        }
      ]
    end

    it 'ingests suppliers and their branches' do
      ingest(suppliers)
      page = all_branches_page
      expect(page).to have_content('3 results'), response.body
    end

    it 'destroys all suppliers and their branches before ingesting' do
      2.times { ingest(suppliers) }
      page = all_branches_page
      expect(page).to have_content('3 results'), response.body
    end
  end

  private

  def ingest(suppliers)
    post uploads_path, params: suppliers.to_json, headers: headers
    expect(response).to have_http_status(:created)
  end

  def all_branches_page
    get branches_path
    Capybara.string(response.body)
  end
end
