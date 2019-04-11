require 'rails_helper'

RSpec.describe 'Ingest facilities management suppliers', type: :request do
  describe 'POST /uploads' do
    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
    let(:suppliers) do
      [
        {
          'supplier_id' => SecureRandom.uuid,
          'supplier_name' => Faker::Company.unique.name,
          'contact_name' => Faker::Name.unique.name,
          'contact_email' => Faker::Internet.unique.email,
          'contact_phone' => Faker::PhoneNumber.unique.phone_number,
        },
        {
          'supplier_id' => SecureRandom.uuid,
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
        count = CCS::FM::Supplier.count
        ingest(suppliers)
        expect(response).to have_http_status(:created)
        expect(CCS::FM::Supplier.count).to eq(count + 2)
      end

      it 'destroys all suppliers before ingesting' do
        count = CCS::FM::Supplier.count
        2.times { ingest(suppliers) }
        expect(CCS::FM::Supplier.count).to eq(count + 2)
      end
    end

    context 'when upload privileges not set' do
      before do
        allow(Marketplace).to receive(:upload_privileges?).and_return(false)
        Rails.application.reload_routes!
      end

      after do
        allow(Marketplace).to receive(:upload_privileges?).and_call_original
        Rails.application.reload_routes!
      end

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
