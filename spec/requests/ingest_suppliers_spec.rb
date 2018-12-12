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
              'postcode' => valid_fake_postcode,
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
              'postcode' => valid_fake_postcode,
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
              'postcode' => valid_fake_postcode,
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

    context 'when upload privileges is set' do
      before do
        allow(Marketplace).to receive(:upload_privileges?).and_return(true)
        Rails.application.reload_routes!
      end

      after do
        allow(Marketplace).to receive(:upload_privileges?).and_call_original
        Rails.application.reload_routes!
      end

      it 'ingests suppliers and their branches' do
        ingest(suppliers)
        expect(response).to have_http_status(:created)
        expect(SupplyTeachers::Branch.count).to eq(3)
      end

      it 'destroys all suppliers and their branches before ingesting' do
        2.times { ingest(suppliers) }
        expect(SupplyTeachers::Branch.count).to eq(3)
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
    post '/supply-teachers/uploads', params: suppliers.to_json, headers: headers
  end
end
