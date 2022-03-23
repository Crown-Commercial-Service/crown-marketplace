require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Admin::HomeController do
  let(:default_params) { { service: 'facilities_management/admin', framework: 'RM3830' } }

  describe 'GET #index' do
    context 'when not logged in' do
      before { get :index }

      it 'redirects to the sign in page' do
        expect(response).to redirect_to facilities_management_rm3830_admin_new_user_session_path
      end
    end

    context 'when logged in as fm admin' do
      login_fm_admin

      before { get :index }

      it 'renders the index page' do
        expect(response).to render_template(:index)
      end
    end

    context 'when not logged in as fm admin' do
      login_fm_buyer

      before { get :index }

      it 'redirects to the not permitted page' do
        expect(response).to redirect_to not_permitted_path(service: 'facilities_management')
      end
    end

    context 'when the framework is not recognised' do
      let(:default_params) { { service: 'facilities_management/admin', framework: 'RM007' } }

      login_fm_admin

      before { get :index }

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

  describe 'validate service' do
    context 'when the service is not a valid service' do
      let(:default_params) { { service: 'apprenticeships' } }

      it 'renders the erros_not_found page' do
        get :index

        expect(response).to redirect_to errors_404_path
      end
    end
  end
end
