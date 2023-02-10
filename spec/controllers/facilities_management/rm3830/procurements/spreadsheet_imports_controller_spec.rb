require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Procurements::SpreadsheetImportsController do
  let(:default_params) { { service: 'facilities_management', framework: framework } }
  let(:framework) { 'RM3830' }
  let(:spreadsheet_import) { create(:facilities_management_rm3830_procurement_spreadsheet_import, procurement: procurement) }
  let(:procurement) { create(:facilities_management_rm3830_procurement, aasm_state: 'detailed_search_bulk_upload', user: subject.current_user) }

  login_fm_buyer_with_details

  describe 'GET new' do
    context 'when logging in with buyer detail' do
      before { get :new, params: { procurement_id: procurement.id } }

      it 'renders the correct template' do
        expect(response).to render_template(:new)
      end

      it 'creates a new spreadsheet_import' do
        expect(assigns(:spreadsheet_import).present?).to be true
      end
    end

    context 'when logging in without buyer details' do
      login_fm_buyer

      before { get :new, params: { procurement_id: procurement.id } }

      it 'is expected to redirect to edit_facilities_management_buyer_detail_path' do
        expect(response).to redirect_to edit_facilities_management_buyer_detail_path(framework, controller.current_user.buyer_detail)
      end
    end
  end

  describe 'POST create' do
    let(:fake_file) { File.open(FacilitiesManagement::RM3830::SpreadsheetImporter::TEMPLATE_FILE_PATH) }

    context 'when uploading the file' do
      let(:valid) { false }

      before do
        allow(spreadsheet_import).to receive(:save).and_return(valid)
        allow(spreadsheet_import).to receive(:save).with(context: :upload).and_return(valid)
        allow(FacilitiesManagement::RM3830::SpreadsheetImport).to receive(:new).with(anything).and_return(spreadsheet_import)
        allow(FacilitiesManagement::RM3830::UploadSpreadsheetWorker).to receive(:perform_async).with(spreadsheet_import.id).and_return(true)
        post :create, params: { procurement_id: procurement.id, facilities_management_rm3830_spreadsheet_import: { spreadsheet_file: fake_file } }
      end

      context 'when the spreadsheet is uploaded is valid' do
        let(:valid) { true }

        it 'redirects to the show page' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_spreadsheet_import_path(procurement_id: procurement.id, id: spreadsheet_import.id)
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
        post :create, params: { procurement_id: procurement.id, cancel_and_return: 'Cancel and return to services and buildings template', facilities_management_rm3830_spreadsheet_import: { spreadsheet_file: fake_file } }
      end

      it 'redirects to the spreadsheet template page' do
        expect(response).to redirect_to facilities_management_rm3830_procurement_path(id: procurement.id, spreadsheet: true)
      end

      it 'deletes the spreadsheet import' do
        procurement.reload
        expect(procurement.spreadsheet_import.present?).to be false
      end
    end
  end

  describe 'GET show' do
    context 'and the spreadsheet import exists' do
      before { get :show, params: { id: spreadsheet_import.id, procurement_id: procurement.id } }

      it 'renders the correct template' do
        expect(response).to render_template(:show)
      end

      it 'assigns the correct spreadsheet import' do
        expect(assigns(:spreadsheet_import)).to eq spreadsheet_import
      end
    end

    context 'when the spreadsheet import does not exist' do
      it 'redirects to new_facilities_management_rm3830_procurement_spreadsheet_import_path' do
        get :show, params: { id: procurement.id, procurement_id: procurement.id }

        expect(response).to redirect_to new_facilities_management_rm3830_procurement_spreadsheet_import_path(procurement_id: procurement.id)
      end
    end

    context 'and the spreadsheet import failed' do
      render_views

      before do
        spreadsheet_import.update(aasm_state: 'failed', import_errors: import_errors)
        get :show, params: { id: spreadsheet_import.id, procurement_id: procurement.id }
      end

      context 'and there are generic errors' do
        let(:import_errors) { { other_errors: { generic_error: 'generic error' } } }

        it 'renders the failed_generic template' do
          expect(response).to render_template(partial: '_failed_generic')
        end

        it 'no errors are collected' do
          expect(assigns(:error_lists)).to be_nil
        end
      end

      context 'and there are template errors' do
        let(:import_errors) { { other_errors: { file_check_error: :not_started } } }

        it 'renders the failed_template template' do
          expect(response).to render_template(partial: '_failed_template')
        end

        it 'no errors are collected' do
          expect(assigns(:error_lists)).to be_nil
        end
      end

      context 'and there are errors on the buildings' do
        let(:import_errors) do
          { 'Building 1': {
            building_name: 'Building 1',
            building_errors: { building_name: [{ error: :blank }], other_building_type: [{ error: :too_long }] },
            procurement_building_errors: {},
            procurement_building_services_errors: {}
          } }
        end

        it 'renders the failed_non_generic template' do
          expect(response).to render_template(partial: '_failed_non_generic')
        end

        it 'has collected the errors' do
          expect(assigns(:error_lists)).to match({
                                                   building_errors: [{ attribute: :building_name, building_name: 'Building 1', errors: [:blank] }, { attribute: :other_building_type, building_name: 'Building 1', errors: [:too_long] }],
                                                   service_matrix_errors: [],
                                                   service_volume_errors: [],
                                                   lift_errors: [],
                                                   service_hour_errors: [],
                                                   other_errors: []
                                                 })
        end
      end
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

  describe 'DELETE destroy' do
    before { delete :destroy, params: { id: spreadsheet_import.id, procurement_id: procurement.id } }

    it 'deletes the spreadsheet import' do
      expect(FacilitiesManagement::RM3830::SpreadsheetImport.exists?(spreadsheet_import.id)).to be false
    end

    it 'redirects to new_facilities_management_rm3830_procurement_spreadsheet_import_path' do
      expect(response).to redirect_to new_facilities_management_rm3830_procurement_spreadsheet_import_path(procurement_id: procurement.id)
    end
  end
end
