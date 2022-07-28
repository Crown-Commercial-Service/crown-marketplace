require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Admin::HomeController do
  let(:default_params) { { service: 'facilities_management/admin', framework: 'RM3830' } }

  describe 'GET accessibility_statement' do
    it 'renders the accessibility_statement page' do
      get :accessibility_statement

      expect(response).to render_template('home/accessibility_statement')
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

  describe 'PUT update_cookie_settings' do
    context 'when enableing the cookies' do
      before do
        %i[_ga_cookie _gi_cookie _cls_cookie].each do |cookie_name|
          cookies[cookie_name] = { value: 'test_cookie', domain: '.crowncommercial.gov.uk', path: '/' }
        end

        put :update_cookie_settings, params: { ga_cookie_usage: 'true' }
      end

      it 'sets the cookie' do
        expect(cookies[:crown_marketplace_google_analytics_enabled]).to eq('true')

        %i[_ga_cookie _gi_cookie _cls_cookie].each do |cookie_name|
          expect(cookies[cookie_name]).to eq 'test_cookie'
        end
      end

      it 'updates the cookies_updated param' do
        expect(controller.params[:cookies_updated]).to be true
      end

      it 'renders the cookie_settings template' do
        expect(response).to render_template('home/cookie_settings')
      end
    end

    context 'when disabling the cookies' do
      before do
        cookies[:crown_marketplace_google_analytics_enabled] = { value: 'true' }

        %i[_ga_cookie _gi_cookie _cls_cookie].each do |cookie_name|
          cookies[cookie_name] = { value: 'test_cookie', domain: '.crowncommercial.gov.uk', path: '/' }
        end

        put :update_cookie_settings, params: { ga_cookie_usage: 'false' }
      end

      it 'deletes the cookie' do
        %w[_ga_cookie _gi_cookie _cls_cookie crown_marketplace_google_analytics_enabled].each do |cookie_name|
          expect(response.cookies[cookie_name]).to be_nil
        end
      end

      it 'updates the cookies_updated param' do
        expect(controller.params[:cookies_updated]).to be true
      end

      it 'renders the cookie_settings template' do
        expect(response).to render_template('home/cookie_settings')
      end
    end
  end

  describe 'GET not_permitted' do
    it 'renders the not_permitted page' do
      get :not_permitted

      expect(response).to render_template('home/not_permitted')
    end
  end

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
        expect(response).to redirect_to '/facilities-management/RM3830/admin/not-permitted'
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
