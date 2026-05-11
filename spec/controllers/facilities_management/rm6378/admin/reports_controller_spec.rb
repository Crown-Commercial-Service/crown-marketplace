require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6378::Admin::ReportsController do
  let(:default_params) { { service: 'facilities_management/admin', framework: framework } }
  let(:framework) { 'RM6378' }

  before { allow(ReportWorker).to receive(:perform_async) }

  describe 'GET index' do
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

      context 'and the framework dose not exist' do
        it 'renders the unrecognised framework page with the right http status' do
          get :index, params: { framework: 'RM3788' }

          expect(response).to render_template('home/unrecognised_framework')
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end

  describe 'GET new' do
    login_fm_admin

    it 'renders the new page' do
      get :new

      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let(:report) { Report.first }

    login_fm_admin

    before { post :create, params: report_params }

    context 'when the upload is valid' do
      let(:report_params) { { report: { start_date_dd: '01', start_date_mm: '01', start_date_yyyy: '2020', end_date_dd: '01', end_date_mm: '01', end_date_yyyy: '2021' } } }

      it 'redirects to the show page' do
        expect(response).to redirect_to facilities_management_rm6378_admin_report_path(report)
      end

      it 'changes the state to generating_csv' do
        expect(report.generating_csv?).to be true
      end
    end

    context 'when the upload is invalid' do
      let(:report_params) { { report: { start_date_dd: '', start_date_mm: '', start_date_yyyy: '', end_date_dd: '', end_date_mm: '', end_date_yyyy: '' } } }

      it 'renders the new page' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET show' do
    let(:report) { create(:report) }

    login_fm_admin

    before { get :show, params: { id: report.id } }

    it 'renders the show template' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET progress' do
    let(:report) { create(:report, aasm_state: 'completed') }

    login_fm_admin

    before { get :progress, params: { report_id: report.id } }

    it 'renders the aasm_state as JSON' do
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response.parsed_body).to eq 'import_status' => 'completed'
    end
  end
end
