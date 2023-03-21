require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Admin::ChangeLogsController do
  let(:default_params) { { service: 'facilities_management/admin', framework: 'RM6232' } }

  login_fm_admin

  describe 'GET index' do
    context 'when logged in as an fm admin' do
      before { get :index }

      it 'renders the index' do
        expect(response).to render_template(:index)
      end

      it 'gets a list of all the audits' do
        expect(assigns(:audit_logs).size).to eq 1
      end
    end

    context 'when not logged in as an fm admin' do
      login_fm_buyer

      it 'redirects to not permitted page' do
        get :index
        expect(response).to redirect_to '/facilities-management/RM6232/admin/not-permitted'
      end
    end
  end

  describe 'GET index with csv fromat' do
    before do
      allow(FacilitiesManagement::RM6232::Admin::ChangeLogsCsvGenerator).to receive(:generate_csv).and_return("\n")

      get :index, format: :csv
    end

    it 'download the csv' do
      expect(response.headers['Content-Disposition']).to include 'filename="Full change logs'
      expect(response.headers['Content-Type']).to eq 'text/csv'
    end
  end

  describe 'GET show' do
    let(:supplier_data) { FacilitiesManagement::RM6232::Admin::SupplierData.latest_data }
    let(:supplier) { supplier_data.data.first }

    render_views

    before { get :show, params: { change_log_id: change_log_id, change_type: change_type } }

    context 'when there are change_type is upload' do
      let(:change_type) { 'upload' }
      let(:change_log_id) { supplier_data.id }

      it 'renders the upload partial' do
        expect(response).to render_template(partial: '_upload')
      end
    end

    context 'when there are change_type is details' do
      let(:change_type) { 'details' }
      let(:change_log_id) { create(:facilities_management_rm6232_admin_supplier_data_edit, :with_details, user: controller.current_user).id }

      it 'renders the details partial' do
        expect(response).to render_template(partial: '_details')
      end
    end

    context 'when there are change_type is lot_data' do
      let(:change_type) { 'lot_data' }
      let(:change_log_id) { create(:facilities_management_rm6232_admin_supplier_data_edit, :with_service_lot_data, user: controller.current_user).id }

      it 'renders the lot_data partial' do
        expect(response).to render_template(partial: '_lot_data')
      end
    end

    context 'when there are change_type is not upload, details or lot_data' do
      let(:change_type) { 'service_codes' }
      let(:change_log_id) { supplier_data.id }

      it 'redirects to the index page' do
        expect(response).to redirect_to facilities_management_rm6232_admin_change_logs_path
      end
    end
  end
end
