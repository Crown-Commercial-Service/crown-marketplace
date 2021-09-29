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
end
