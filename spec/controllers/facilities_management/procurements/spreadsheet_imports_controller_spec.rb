require 'rails_helper'

RSpec.describe FacilitiesManagement::Procurements::SpreadsheetImportsController, type: :controller do
  let(:default_params) { { service: 'facilities_management' } }
  let(:spreadsheet_import) { create(:facilities_management_procurement_spreadsheet_import, procurement: procurement) }
  let(:procurement) { create(:facilities_management_procurement, aasm_state: 'detailed_search_bulk_upload', user: subject.current_user) }

  login_fm_buyer_with_details

  describe 'GET new' do
    context 'when logging in with buyer detail' do
      before { get :new, params: { procurement_id: procurement.id } }

      it 'renders the correct template' do
        expect(response).to render_template(:new)
      end

      it 'creates a new spreadsheet_import' do
        expect(assigns(:spreadsheet_import).present?).to eq true
      end
    end

    context 'when logging in without buyer details' do
      login_fm_buyer

      before { get :new, params: { procurement_id: procurement.id } }

      it 'is expected to redirect to edit_facilities_management_buyer_detail_path' do
        expect(response).to redirect_to edit_facilities_management_buyer_detail_path(controller.current_user.buyer_detail)
      end
    end
  end

  describe 'POST create' do
    let(:fake_file) { File.open(FacilitiesManagement::SpreadsheetImporter::TEMPLATE_FILE_PATH) }

    context 'when uploading the file' do
      let(:valid) { false }

      before do
        allow(spreadsheet_import).to receive(:save).and_return(valid)
        allow(spreadsheet_import).to receive(:save).with(context: :upload).and_return(valid)
        allow(FacilitiesManagement::SpreadsheetImport).to receive(:new).with(anything).and_return(spreadsheet_import)
        allow(FacilitiesManagement::UploadSpreadsheetWorker).to receive(:perform_async).with(spreadsheet_import.id).and_return(true)
        post :create, params: { procurement_id: procurement.id, facilities_management_spreadsheet_import: { spreadsheet_file: fake_file } }
      end

      context 'when the spreadsheet is uploaded is valid' do
        let(:valid) { true }

        it 'redirects to the show page' do
          expect(response).to redirect_to facilities_management_procurement_spreadsheet_import_path(procurement_id: procurement.id, id: spreadsheet_import.id)
        end

        it 'changes the state to importing' do
          expect(spreadsheet_import.importing?).to be true
        end
      end

      context 'when the spreadsheet is uploaded is not valid' do
        it 'renders the new page' do
          expect(response).to render_template(:new)
        end
      end
    end

    context 'when canceling and returning' do
      before do
        spreadsheet_import
        post :create, params: { procurement_id: procurement.id, cancel_and_return: 'Cancel and return to services and buildings template', facilities_management_spreadsheet_import: { spreadsheet_file: fake_file } }
      end

      it 'redirects to the spreadsheet template page' do
        expect(response).to redirect_to facilities_management_procurement_path(id: procurement.id, 'spreadsheet': true)
      end

      it 'deletes the spreadsheet import' do
        procurement.reload
        expect(procurement.spreadsheet_import.present?).to be false
      end
    end
  end

  describe 'GET show' do
    before { get :show, params: { id: spreadsheet_import.id, procurement_id: procurement.id } }

    it 'renders the correct template' do
      expect(response).to render_template(:show)
    end

    it 'assigns the correct spreadsheet import' do
      expect(assigns(:spreadsheet_import)).to eq spreadsheet_import
    end
  end

  describe 'GET progress' do
    let(:result) { JSON.parse(response.body) }

    context 'when the user can view the spreadsheet' do
      before do
        spreadsheet_import.update(data_import_state: state)
        get :progress, params: { spreadsheet_import_id: spreadsheet_import.id, procurement_id: procurement.id }
      end

      context 'when the spreadsheet is checking_file' do
        let(:state) { 'checking_file' }

        it 'returns true for continue' do
          expect(result['import_status']).to eq state
        end
      end

      context 'when the spreadsheet is processing_file' do
        let(:state) { 'processing_file' }

        it 'returns true for continue' do
          expect(result['import_status']).to eq state
        end
      end

      context 'when the spreadsheet is checking_processed_data' do
        let(:state) { 'checking_processed_data' }

        it 'returns true for continue' do
          expect(result['import_status']).to eq state
        end
      end

      context 'when the spreadsheet is saving_data' do
        let(:state) { 'saving_data' }

        it 'returns true for continue' do
          expect(result['import_status']).to eq state
        end
      end

      context 'when the spreadsheet is data_import_succeed' do
        let(:state) { 'data_import_succeed' }

        it 'returns true for continue' do
          expect(result['import_status']).to eq state
        end
      end

      context 'when the spreadsheet is data_import_failed' do
        let(:state) { 'data_import_failed' }

        it 'returns true for continue' do
          expect(result['import_status']).to eq state
        end
      end
    end
  end
end
