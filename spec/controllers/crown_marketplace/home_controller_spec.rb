require 'rails_helper'

RSpec.describe CrownMarketplace::HomeController, type: :controller do
  let(:default_params) { { service: 'crown_marketplace' } }

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
    let(:cookie_names) { response.cookies.map { |cookie_name, _| cookie_name } }

    before do
      %i[_ga_cookie _gi_cookie _cls_cookie].each do |cookie_name|
        cookies[cookie_name] = { value: 'test_cookie', domain: '.crowncommercial.gov.uk', path: '/' }
      end

      put :update_cookie_settings, params: update_params
    end

    context 'when enableing the ga cookies and disableing the glassbox cookies' do
      let(:update_params) { { ga_cookie_usage: 'true', glassbox_cookie_usage: 'false' } }

      it 'updates the cookie preferences' do
        expect(JSON.parse(response.cookies['crown_marketplace_cookie_options_v1'])).to eq(
          {
            'settings_viewed' => true,
            'google_analytics_enabled' => true,
            'glassbox_enabled' => false
          }
        )
      end

      it 'does not delete the ga cookies' do
        %w[_ga_cookie _gi_cookie].each do |cookie_name|
          expect(cookie_names).not_to include cookie_name
        end
      end

      it 'does delete the glassbox cookies' do
        %w[_cls_cookie].each do |cookie_name|
          expect(cookie_names).to include cookie_name

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

    context 'when enableing the glassbox cookies and disableing the ga cookies' do
      let(:update_params) { { ga_cookie_usage: 'false', glassbox_cookie_usage: 'true' } }

      it 'updates the cookie preferences' do
        expect(JSON.parse(response.cookies['crown_marketplace_cookie_options_v1'])).to eq(
          {
            'settings_viewed' => true,
            'google_analytics_enabled' => false,
            'glassbox_enabled' => true
          }
        )
      end

      it 'does not delete the glassbox cookies' do
        %w[_cls_cookie].each do |cookie_name|
          expect(cookie_names).not_to include cookie_name
        end
      end

      it 'does delete the ga cookies' do
        %w[_ga_cookie _gi_cookie].each do |cookie_name|
          expect(cookie_names).to include cookie_name

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

    context 'when enableing the ga cookies and the glassbox cookies' do
      let(:update_params) { { ga_cookie_usage: 'true', glassbox_cookie_usage: 'true' } }

      it 'updates the cookie preferences' do
        expect(JSON.parse(response.cookies['crown_marketplace_cookie_options_v1'])).to eq(
          {
            'settings_viewed' => true,
            'google_analytics_enabled' => true,
            'glassbox_enabled' => true
          }
        )
      end

      it 'does not delete the ga and glassbox cookies' do
        %w[_ga_cookie _gi_cookie _cls_cookie].each do |cookie_name|
          expect(cookie_names).not_to include cookie_name
        end
      end

      it 'updates the cookies_updated param' do
        expect(controller.params[:cookies_updated]).to be true
      end

      it 'renders the cookie_settings template' do
        expect(response).to render_template('home/cookie_settings')
      end
    end

    context 'when disableing the ga cookies and the glassbox cookies' do
      let(:update_params) { { ga_cookie_usage: 'false', glassbox_cookie_usage: 'false' } }

      it 'updates the cookie preferences' do
        expect(JSON.parse(response.cookies['crown_marketplace_cookie_options_v1'])).to eq(
          {
            'settings_viewed' => true,
            'google_analytics_enabled' => false,
            'glassbox_enabled' => false
          }
        )
      end

      it 'does delete the ga and glassbox cookies' do
        %w[_ga_cookie _gi_cookie _cls_cookie].each do |cookie_name|
          expect(cookie_names).to include cookie_name

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
        expect(response).to redirect_to crown_marketplace_new_user_session_path
      end
    end

    context 'when logged in as a user support user' do
      login_user_support_admin

      it 'renders the index page' do
        get :index

        expect(response).to render_template(:index)
      end
    end

    context 'when logged in as a user admin user' do
      login_user_admin

      it 'renders the index page' do
        get :index

        expect(response).to render_template(:index)
      end

      context 'when logged in as a super admin user' do
        login_super_admin

        it 'renders the index page' do
          get :index

          expect(response).to render_template(:index)
        end
      end
    end

    context 'when not logged in as an fm admin' do
      login_fm_admin

      before { get :index }

      it 'redirects to the not permitted page' do
        expect(response).to redirect_to '/crown-marketplace/not-permitted'
      end
    end

    context 'when not logged in a non-admin' do
      login_fm_buyer

      before { get :index }

      it 'redirects to the not permitted page' do
        expect(response).to redirect_to '/crown-marketplace/not-permitted'
      end
    end
  end
end
