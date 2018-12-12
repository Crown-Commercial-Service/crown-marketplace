require 'rails_helper'

RSpec.describe SupplyTeachers::UploadsController, type: :controller do
  describe 'POST create' do
    let(:suppliers) { [] }

    before do
      allow(SupplyTeachers::Upload).to receive(:upload!)
    end

    context 'when the app has upload privileges' do
      before do
        allow(Marketplace).to receive(:upload_privileges?).and_return(true)
        Rails.application.reload_routes!
      end

      after do
        allow(Marketplace).to receive(:upload_privileges?).and_call_original
        Rails.application.reload_routes!
      end

      it 'creates suppliers and their associated data from JSON' do
        post :create, body: suppliers.to_json

        expect(SupplyTeachers::Upload)
          .to have_received(:upload!)
          .with(suppliers)
      end

      it 'responds with HTTP created status' do
        post :create, body: suppliers.to_json

        expect(response).to have_http_status(:created)
      end

      context 'when model validation error occurs' do
        let(:supplier) { build(:supply_teachers_supplier) }

        before do
          supplier.errors.add(:name, 'error-message')
          allow(SupplyTeachers::Upload)
            .to receive(:upload!)
            .and_raise(ActiveRecord::RecordInvalid.new(supplier))
        end

        it 'responds with 422 Unprocessable Entity' do
          post :create, body: suppliers.to_json

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'responds with JSON in body with details of the error' do
          post :create, body: suppliers.to_json

          body = JSON.parse(response.body)
          expect(body['record']).to include('name' => supplier.name)
          expect(body['record_class']).to eq('SupplyTeachers::Supplier')
          expect(body['errors']).to eq('name' => ['error-message'])
        end
      end

      context 'when JSON is invalid' do
        it 'raises JSON::ParserError' do
          expect do
            post :create, body: '{'
          end.to raise_error(JSON::ParserError)
        end
      end
    end
  end
end
