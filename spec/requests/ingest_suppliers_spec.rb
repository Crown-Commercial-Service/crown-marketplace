require 'rails_helper'

RSpec.describe 'Ingest suppliers', type: :request do
  describe 'POST /uploads' do
    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
    let(:suppliers) do
      [
        {
          supplier_name: 'First Supplier',
          branches: [
            {
              postcode: 'TN33 0PQ',
              contacts: [
                {
                  name: 'Emma Flynn',
                  email: 'emma.flynn@example.com'
                }
              ]
            },
            {
              postcode: 'LU7 0JL',
              contacts: [
                {
                  name: 'Jimmy Kent',
                  email: 'jimmy.kent@example.com'
                }
              ]
            }
          ]
        },
        {
          supplier_name: 'Second Supplier',
          branches: [
            {
              postcode: 'LS15 8GB',
              contacts: [
                {
                  name: 'Jodie Edwards',
                  email: 'jodie.edwards@example.com'
                }
              ]
            }
          ]
        }
      ]
    end

    it 'ingests suppliers' do
      post uploads_path, params: suppliers.to_json, headers: headers
      expect(response).to have_http_status(:created)

      get branches_path
      page = Capybara.string(response.body)
      expect(page).to have_content('3 results'), response.body
    end
  end
end
