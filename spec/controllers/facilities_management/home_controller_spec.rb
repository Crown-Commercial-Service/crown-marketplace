require 'rails_helper'

RSpec.describe FacilitiesManagement::HomeController, type: :controller do
  let(:default_params) { { service: 'facilities_management' } }

  describe 'GET not_permitted' do
    it 'renders the not_permitted page' do
      get :not_permitted
      expect(response).to render_template(:not_permitted)
    end
  end

  describe 'GET accessibility_statement' do
    it 'renders the accessibility_statement page' do
      get :accessibility_statement
      expect(response).to render_template(:accessibility_statement)
    end
  end

  describe 'GET cookie_policy' do
    it 'renders the cookie policy page' do
      get :cookie_policy
      expect(response).to render_template('home/cookie_policy')
    end
  end

  describe 'GET cookie_settings' do
    it 'renders the cookie settings page' do
      get :cookie_settings
      expect(response).to render_template('home/cookie_settings')
    end
  end

  describe 'GET framework' do
    context 'when RM6232 is live in the future' do
      include_context 'and RM6232 is not live'

      it 'redirects to the RM3830 home page' do
        get :framework
        expect(response).to redirect_to facilities_management_rm3830_path
      end

      context 'when the user is logged in without details' do
        login_fm_buyer

        it 'redirects to the RM3830 home page' do
          get :framework
          expect(response).to redirect_to facilities_management_rm3830_path
        end
      end
    end

    context 'when RM6232 is live' do
      it 'redirects to the RM6232 home page' do
        get :framework
        expect(response).to redirect_to facilities_management_rm6232_path
      end

      context 'when the user is logged in without details' do
        login_fm_buyer

        it 'redirects to the RM6232 home page' do
          get :framework
          expect(response).to redirect_to facilities_management_rm6232_path
        end
      end
    end
  end

  describe 'GET index' do
    context 'when RM6232 is live in the future' do
      include_context 'and RM6232 is not live'

      it 'renders the unrecognised framework page with the right http status' do
        get :index, params: { framework: 'RM6232' }

        expect(response).to render_template('home/unrecognised_framework')
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when RM6232 is live' do
      # This is because in practice, the rails router will have already used the correct framework controller,
      # therfore, this test is just to make sure that the UnrecognisedLiveFrameworkError is not invoked
      it 'renders the unrecognised framework page with the right http status' do
        expect do
          get :index, params: { framework: 'RM6232' }
        end.to raise_error(ActionController::MissingExactTemplate)
      end
    end
  end
end
