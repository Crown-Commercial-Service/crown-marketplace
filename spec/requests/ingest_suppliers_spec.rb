require 'rails_helper'

RSpec.describe 'Ingest suppliers', type: :request do
  describe 'POST /uploads' do
    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
    let(:suppliers) do
      [
        {
          'supplier_name' => 'First Supplier',
          'branches' => [
            {
              'postcode' => 'TN33 0PQ',
              'telephone' => '020 7946 0001',
              'contacts' => [
                {
                  'name' => 'Emma Flynn',
                  'email' => 'emma.flynn@example.com'
                }
              ]
            },
            {
              'postcode' => 'LU7 0JL',
              'telephone' => '020 7946 0002',
              'contacts' => [
                {
                  'name' => 'Jimmy Kent',
                  'email' => 'jimmy.kent@example.com'
                }
              ]
            }
          ]
        },
        {
          'supplier_name' => 'Second Supplier',
          'branches' => [
            {
              'postcode' => 'LS15 8GB',
              'telephone' => '020 7946 0003',
              'contacts' => [
                {
                  'name' => 'Jodie Edwards',
                  'email' => 'jodie.edwards@example.com'
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
