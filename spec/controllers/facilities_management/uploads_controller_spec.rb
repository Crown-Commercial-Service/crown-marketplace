require 'rails_helper'

RSpec.describe FacilitiesManagement::UploadsController, type: :controller do
  describe 'POST create' do
    let(:suppliers) { [] }

    before do
      allow(FacilitiesManagement::Upload)
        .to receive(:upload_json!)
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

        expect(FacilitiesManagement::Upload)
          .to have_received(:upload_json!)
          .with(suppliers)
      end

      it 'responds with HTTP created status' do
        post :create, body: suppliers.to_json

        expect(response).to have_http_status(:created)
      end

      context 'when model validation error occurs' do
        let(:ccs_supplier) { build(:ccs_fm_supplier) }

        before do
          ccs_supplier.errors.add(:name, 'error-message')
          allow(FacilitiesManagement::Upload)
            .to receive(:upload_json!)
            .and_raise(ActiveRecord::RecordInvalid.new(ccs_supplier))
        end

        it 'responds with 422 Unprocessable Entity' do
          post :create, body: suppliers.to_json

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'responds with JSON in body and details of the error' do
          post :create, body: suppliers.to_json

          body = JSON.parse(response.body)
          # expect(body['record']).to include('data')
          expect(body['record']['data']).to include('supplier_name' => ccs_supplier.data['supplier_name'])
          expect(body['record_class']).to eq('CCS::FM::Supplier')
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
