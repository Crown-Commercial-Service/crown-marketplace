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
              postcode: 'TN33 0PQ'
            },
            {
              postcode: 'LU7 0JL'
            }
          ]
        },
        {
          supplier_name: 'Second Supplier',
          branches: [
            {
              postcode: 'LS15 8GB'
            }
          ]
        }
      ]
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'ingests suppliers' do
      post uploads_path, params: suppliers.to_json, headers: headers
      expect(response).to have_http_status(:created)

      get branches_path
      page = Capybara.string(response.body)
      expect(page).to have_content('3 results'), response.body
    end
    # rubocop:enable RSpec/MultipleExpectations
  end
end
