require 'rails_helper'

module ManagementConsultancy
  RSpec.describe UploadsController, type: :controller do
    describe 'POST create' do
      let(:suppliers) { [] }

      before do
        allow(Upload).to receive(:create!)
      end

      it 'creates suppliers and their associated data from JSON' do
        post :create, body: suppliers.to_json

        expect(Upload).to have_received(:create!).with(suppliers)
      end

      it 'responds with HTTP created status' do
        post :create, body: suppliers.to_json

        expect(response).to have_http_status(:created)
      end

      context 'when model validation error occurs' do
        before do
          allow(Upload).to receive(:create!).and_raise(ActiveRecord::RecordInvalid)
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
