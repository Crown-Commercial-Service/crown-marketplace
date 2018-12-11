require 'rails_helper'

RSpec.describe FacilitiesManagement::UploadsController, type: :controller do
  describe 'POST create' do
    let(:suppliers) { [] }

    before do
      allow(FacilitiesManagement::Upload)
        .to receive(:upload!)
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
          .to have_received(:upload!)
          .with(suppliers)
      end

      it 'responds with HTTP created status' do
        post :create, body: suppliers.to_json

        expect(response).to have_http_status(:created)
      end

      context 'when model validation error occurs' do
        before do
          allow(FacilitiesManagement::Upload)
            .to receive(:upload!)
            .and_raise(ActiveRecord::RecordInvalid)
        end

        it 'raises ActiveRecord::RecordInvalid' do
          expect do
            post :create, body: suppliers.to_json
          end.to raise_error(ActiveRecord::RecordInvalid)
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
