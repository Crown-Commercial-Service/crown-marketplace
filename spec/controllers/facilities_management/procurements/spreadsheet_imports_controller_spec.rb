require 'rails_helper'

RSpec.describe FacilitiesManagement::Procurements::SpreadsheetImportsController, type: :controller do
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

  describe 'GET show' do
    before { get :show, params: { id: spreadsheet_import.id, procurement_id: procurement.id } }

    it 'renders the correct template' do
      expect(response).to render_template(:show)
    end

    it 'assigns the correct spreadsheet import' do
      expect(assigns(:spreadsheet_import)).to eq spreadsheet_import
    end
  end
end
