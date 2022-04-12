require 'rails_helper'

RSpec.describe FacilitiesManagement::Admin::HomeController do
  let(:default_params) { { service: 'facilities_management/admin' } }

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
        expect(response).to redirect_to facilities_management_rm3830_admin_path
      end

      context 'when the user is logged in without details' do
        login_fm_buyer

        it 'redirects to the RM3830 home page' do
          get :framework
          expect(response).to redirect_to facilities_management_rm3830_admin_path
        end
      end
    end

    context 'when RM6232 is live' do
      it 'redirects to the RM6232 home page' do
        get :framework
        expect(response).to redirect_to facilities_management_rm6232_admin_path
      end

      context 'when the user is logged in without details' do
        login_fm_buyer

        it 'redirects to the RM6232 home page' do
          get :framework
          expect(response).to redirect_to facilities_management_rm6232_admin_path
        end
      end
    end
  end

  describe 'GET index' do
    # Both of these tests check for the MissingExactTemplate because in practice, the rails router will have already used the correct framework controller,
    # therefore, this test is just to make sure that the UnrecognisedFrameworkError is not invoked (even when the framework is not live)
    context 'when RM6232 is live in the future' do
      include_context 'and RM6232 is not live'

      it 'raises the MissingExactTemplate error' do
        expect do
          get :index, params: { framework: 'RM6232' }
        end.to raise_error(ActionController::MissingExactTemplate)
      end
    end

    context 'when RM6232 is live' do
      it 'raises the MissingExactTemplate error' do
        expect do
          get :index, params: { framework: 'RM6232' }
        end.to raise_error(ActionController::MissingExactTemplate)
      end
    end

    context 'when a framework that is not real is used' do
      it 'renders the unrecognised framework page with the right http status' do
        get :index, params: { framework: 'RM1234' }

        expect(response).to render_template('home/unrecognised_framework')
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
