require 'rails_helper'

RSpec.describe 'Ingest facilities management suppliers', type: :request do
  describe 'POST /uploads' do
    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
    let(:suppliers) do
      [
        {
          'supplier_name' => Faker::Company.unique.name,
          'contact_name' => Faker::Name.unique.name,
          'contact_email' => Faker::Internet.unique.email,
        },
        {
          'supplier_name' => Faker::Company.unique.name,
          'contact_name' => Faker::Name.unique.name,
          'contact_email' => Faker::Internet.unique.email,
        }
      ]
    end

    it 'ingests suppliers' do
      ingest(suppliers)
      expect(FacilitiesManagementSupplier.count).to eq(2)
    end

    it 'destroys all suppliers before ingesting' do
      2.times { ingest(suppliers) }
      expect(FacilitiesManagementSupplier.count).to eq(2)
    end
  end

  private

  def ingest(suppliers)
    post facilities_management_uploads_path, params: suppliers.to_json, headers: headers
    expect(response).to have_http_status(:created)
  end
end
