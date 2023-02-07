require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Admin::ManagementReportsController do
  let(:default_params) { { service: 'facilities_management/admin', framework: 'RM3830' } }

  login_fm_admin

  before { allow(FacilitiesManagement::RM3830::Admin::ManagementReportWorker).to receive(:perform_async).with(anything).and_return(true) }

  describe 'GET new' do
    it 'renders the new page' do
      get :new

      expect(response).to render_template(:new)
    end

    context 'when not logged in as fm admin' do
      login_fm_buyer

      it 'redirects to the not permitted page' do
        get :new

        expect(response).to redirect_to '/facilities-management/RM3830/admin/not-permitted'
      end
    end

    context 'when the framework is not recognised' do
      let(:default_params) { { service: 'facilities_management/admin', framework: 'RM007' } }

      before { get :new }

      it 'renders the unrecognised framework page with the right http status' do
        expect(response).to render_template('home/unrecognised_framework')
        expect(response).to have_http_status(:bad_request)
      end

      it 'sets the framework variables' do
        expect(assigns(:unrecognised_framework)).to eq 'RM007'
        expect(controller.params[:framework]).to eq FacilitiesManagement::Framework.default_framework
      end
    end
  end

  describe 'POST create' do
    before { post :create, params: management_report_params }

    context 'when the params have been provided' do
      let(:management_report_params) { { facilities_management_rm3830_admin_management_report: { start_date_dd: '01', start_date_mm: '01', start_date_yyyy: '2020', end_date_dd: '01', end_date_mm: '01', end_date_yyyy: '2021' } } }
      let(:management_report) { FacilitiesManagement::RM3830::Admin::ManagementReport.first }

      it 'redirects to the show page' do
        expect(response).to redirect_to facilities_management_rm3830_admin_management_report_path(management_report.id)
      end
    end

    context 'when the params have not been provided' do
      let(:management_report_params) { { facilities_management_rm3830_admin_management_report: { start_date_dd: '', start_date_mm: '', start_date_yyyy: '', end_date_dd: '', end_date_mm: '', end_date_yyyy: '' } } }

      it 'renders the new page' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET show' do
    let(:management_report) { create(:facilities_management_rm3830_admin_management_report, user: controller.current_user) }

    before { get :show, params: { id: management_report.id } }

    it 'renders the show page' do
      expect(response).to render_template(:show)
    end

    it 'assigns the management report' do
      expect(assigns(:management_report).id).to eq management_report.id
    end
  end

  describe 'GET progress' do
    let(:management_report) { create(:facilities_management_rm3830_admin_management_report, user: controller.current_user, aasm_state: status) }

    before { get :progress, params: { id: management_report.id } }

    context 'when the status is generating_csv' do
      let(:status) { 'generating_csv' }

      it 'renders the aasm_state as JSON' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(JSON.parse(response.body)).to eq 'import_status' => 'generating_csv'
      end
    end

    context 'when the status is completed' do
      let(:status) { 'completed' }

      it 'renders the aasm_state as JSON' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(JSON.parse(response.body)).to eq 'import_status' => 'completed'
      end
    end
  end
end
