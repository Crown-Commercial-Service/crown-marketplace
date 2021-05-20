require 'rails_helper'

RSpec.describe FacilitiesManagement::Admin::HomeController do
  let(:default_params) { { service: 'facilities_management/admin' } }

  describe 'GET #index' do
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
  end

  describe 'GET accessibility_statement' do
    login_fm_admin

    it 'renders the accessibility_statement page' do
      get :accessibility_statement
      expect(response).to render_template('home/accessibility_statement')
    end
  end

  describe 'GET cookie_policy' do
    login_fm_admin

    it 'renders the cookie policy page' do
      get :cookie_policy
      expect(response).to render_template('home/cookie_policy')
    end
  end

  describe 'GET cookie_settings' do
    login_fm_admin

    it 'renders the cookie settings page' do
      get :cookie_settings
      expect(response).to render_template('home/cookie_settings')
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
