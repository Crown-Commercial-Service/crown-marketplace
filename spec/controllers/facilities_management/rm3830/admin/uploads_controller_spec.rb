require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Admin::UploadsController do
  let(:default_params) { { service: 'facilities_management/admin', framework: 'RM3830' } }

  describe 'GET index' do
    context 'when not logged in' do
      it 'redirects to the sign-in' do
        get :index

        expect(response).to redirect_to facilities_management_rm3830_admin_new_user_session_path
      end
    end

    context 'when logged in as a buyer' do
      login_fm_buyer

      it 'redirects to not permitted' do
        get :index

        expect(response).to redirect_to '/facilities-management/RM3830/admin/not-permitted'
      end
    end

    context 'when logged in as an admin' do
      login_fm_admin

      context 'and the framework is live' do
        include_context 'and RM3830 is live'

        it 'renders the page' do
          get :index

          expect(response).to render_template(:index)
        end
      end

      context 'and the framework has expired' do
        it 'renders the page' do
          get :index

          expect(response).to render_template(:index)
        end
      end
    end
  end

  describe 'validate service' do
    context 'when the service is not a valid service' do
      let(:default_params) { { service: 'apprenticeships/admin' } }

      it 'renders the erros_not_found page' do
        get :index

        expect(response).to redirect_to errors_404_path
      end
    end
  end

  describe 'GET new' do
    login_fm_admin

    context 'and the framework is live' do
      include_context 'and RM3830 is live'

      it 'renders the new page' do
        get :new

        expect(response).to render_template(:new)
      end
    end

    context 'and the framework has expired' do
      it 'redirects to the facilities_management_rm3830_admin_uploads_path path' do
        get :new

        expect(response).to redirect_to facilities_management_rm3830_admin_uploads_path
      end
    end
  end

  describe 'POST create' do
    let(:file) { Tempfile.new(['valid_file', '.xlsx']) }
    let(:fake_file) { File.open(file.path) }
    let(:upload) { create(:facilities_management_rm3830_admin_upload) }

    login_fm_admin

    after do
      file.unlink
    end

    context 'and the framework is live' do
      include_context 'and RM3830 is live'

      before do
        allow(upload).to receive(:save).and_return(valid)
        allow(upload).to receive(:save).with(context: :upload).and_return(valid)
        allow(FacilitiesManagement::RM3830::Admin::Upload).to receive(:new).with(anything).and_return(upload)
        allow(FacilitiesManagement::RM3830::Admin::FileUploadWorker).to receive(:perform_async).with(upload.id).and_return(true)
        post :create, params: { facilities_management_rm3830_admin_upload: { supplier_data_file: fake_file } }
      end

      context 'when the upload is valid' do
        let(:valid) { true }

        it 'redirects to the show page' do
          expect(response).to redirect_to facilities_management_rm3830_admin_upload_path(upload)
        end

        it 'changes the state to in_progress' do
          expect(upload.in_progress?).to be true
        end
      end

      context 'when the upload is invalid' do
        let(:valid) { false }

        it 'renders the new page' do
          expect(response).to render_template(:new)
        end
      end
    end

    context 'and the framework has expired' do
      it 'redirects to the facilities_management_rm3830_admin_uploads_path path' do
        post :create, params: { facilities_management_rm3830_admin_upload: { supplier_data_file: fake_file } }

        expect(response).to redirect_to facilities_management_rm3830_admin_uploads_path
      end
    end
  end

  describe 'GET show' do
    let(:file) { Tempfile.new(['valid_file', '.xlsx']) }
    let(:fake_file) { File.open(file.path) }
    let(:upload) do
      create(:facilities_management_rm3830_admin_upload, aasm_state:) do |admin_upload|
        admin_upload.supplier_data_file.attach(io: fake_file, filename: 'test_supplier_framework_data_file.xlsx')
      end
    end

    after do
      file.unlink
    end

    login_fm_admin

    before { get :show, params: { id: upload.id } }

    context 'when the upload is published' do
      let(:aasm_state) { 'published' }

      context 'and the framework is live' do
        include_context 'and RM3830 is live'

        it 'renders the show template' do
          expect(response).to render_template(:show)
        end
      end

      context 'and the framework has expired' do
        it 'renders the show template' do
          get :show, params: { id: upload.id }

          expect(response).to render_template(:show)
        end
      end
    end

    context 'when the upload is in an in progress state' do
      let(:aasm_state) { 'processing_files' }

      render_views

      it 'renders the show template and the in_progress partial' do
        expect(response).to render_template(:show)
        expect(response).to render_template(partial: 'facilities_management/rm3830/admin/uploads/_in_progress')
      end
    end

    context 'when the upload has failed' do
      let(:aasm_state) { 'failed' }

      render_views

      it 'renders the show template and the failed partial' do
        expect(response).to render_template(:show)
        expect(response).to render_template(partial: 'facilities_management/rm3830/admin/uploads/_failed')
      end
    end
  end

  describe 'GET progress' do
    let(:upload) { create(:facilities_management_rm3830_admin_upload, aasm_state: 'publishing_data') }

    login_fm_admin

    before { get :progress, params: { upload_id: upload.id } }

    it 'renders the aasm_state as JSON' do
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response.parsed_body).to eq 'import_status' => 'publishing_data'
    end
  end
end
