require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6378::Admin::ChangeLogsController do
  let(:framework_id) { 'RM6378' }
  let(:default_params) { { service: 'facilities_management/admin', framework: framework_id } }

  describe 'GET index' do
    let!(:change_logs) { [5, 4, 3, 2, 1].map { |n| create(:change_log, framework_id: framework_id, created_at: Time.now.in_time_zone('London') - n.days) } }

    context 'when not logged in' do
      it 'redirects to the sign-in' do
        get :index
        expect(response).to redirect_to facilities_management_rm6378_admin_new_user_session_path
      end
    end

    context 'when logged in as a buyer' do
      login_fm_buyer

      it 'redirects to not permitted' do
        get :index
        expect(response).to redirect_to '/facilities-management/RM6378/admin/not-permitted'
      end
    end

    context 'when logged in as an admin' do
      login_fm_admin

      it 'renders the page' do
        get :index
        expect(response).to render_template(:index)
      end

      it 'assigns change_logs' do
        get :index

        assigned_change_logs = assigns(:change_logs)

        expect(assigned_change_logs.count).to eq(5)
        expect(assigned_change_logs.pluck(:id)).to eq(change_logs.map(&:id).reverse)
      end

      context 'and the framework dose not exist' do
        it 'renders the unrecognised framework page with the right http status' do
          get :index, params: { framework: 'RM3826' }

          expect(response).to render_template('home/unrecognised_framework')
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end

  describe 'GET index CSV' do
    login_fm_admin

    before do
      csv_generator = instance_double(ChangeLog::CsvGenerator)
      allow(ChangeLog::CsvGenerator).to receive(:generate_csv).and_return(csv_generator)
      allow(csv_generator).to receive(:generate_csv).and_return("\n")

      get :index, format: :csv
    end

    it 'download the csv' do
      expect(response.headers['Content-Disposition']).to include 'filename="Change log - Facilities Management - RM6378 - '
      expect(response.headers['Content-Type']).to eq 'text/csv'
    end
  end

  describe 'GET show' do
    login_fm_admin

    let(:change_log) { create(:change_log, :"with_#{change_type}_change_type", framework_id:) }

    before { get :show, params: { id: change_log.id } }

    shared_examples 'when testing a change type' do
      it 'sets the change log' do
        expect(assigns(:change_log)).to be_present
      end

      context 'when considering the templates' do
        render_views

        it 'renders change type partial template' do
          expect(response).to have_http_status(:ok)
          expect(response).to render_template(partial: "shared/admin/change_logs/show/_#{change_type}")
        end
      end
    end

    context 'when the change type is upload_supplier_data' do
      let(:change_type) { :upload_supplier_data }

      include_context 'when testing a change type'
    end

    context 'when the change type is update_supplier_information' do
      let(:change_type) { :update_supplier_information }

      include_context 'when testing a change type'
    end

    context 'when the change type is update_supplier_framework_lot_services' do
      let(:change_type) { :update_supplier_framework_lot_services }

      include_context 'when testing a change type'
    end

    context 'when the change type is update_supplier_framework_lot_jurisdictions' do
      let(:change_type) { :update_supplier_framework_lot_jurisdictions }

      include_context 'when testing a change type'
    end

    context 'when the change type is update_supplier_framework_lot_status' do
      let(:change_type) { :update_supplier_framework_lot_status }

      include_context 'when testing a change type'
    end
  end
end
