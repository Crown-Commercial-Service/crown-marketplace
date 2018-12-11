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
          'contact_phone' => Faker::PhoneNumber.unique.phone_number,
        },
        {
          'supplier_name' => Faker::Company.unique.name,
          'contact_name' => Faker::Name.unique.name,
          'contact_email' => Faker::Internet.unique.email,
          'contact_phone' => Faker::PhoneNumber.unique.phone_number,
        }
      ]
    end

    context 'when upload privileges is set' do
      before do
        allow(Marketplace).to receive(:upload_privileges?).and_return(true)
        Rails.application.reload_routes!
      end

      after do
        allow(Marketplace).to receive(:upload_privileges?).and_call_original
        Rails.application.reload_routes!
      end

      it 'ingests suppliers' do
        ingest(suppliers)
        expect(response).to have_http_status(:created)
        expect(FacilitiesManagement::Supplier.count).to eq(2)
      end

      it 'destroys all suppliers before ingesting' do
        2.times { ingest(suppliers) }
        expect(FacilitiesManagement::Supplier.count).to eq(2)
      end
    end

    context 'when upload privileges not set' do
      it 'ingests suppliers and their branches' do
        expect do
          ingest(suppliers)
        end.to raise_error(ActionController::RoutingError)
      end
    end
  end

  private

  def ingest(suppliers)
    post '/facilities-management/uploads', params: suppliers.to_json, headers: headers
  end
end
