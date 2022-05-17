require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::HomeController, type: :controller do
  let(:default_params) { { service: 'facilities_management', framework: 'RM6232' } }

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

  describe 'GET not_permitted' do
    it 'renders the not_permitted page' do
      get :not_permitted

      expect(response).to render_template('home/not_permitted')
    end
  end

  describe 'GET index' do
    context 'when the user is not logged in' do
      it 'renders the index page' do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context 'when the user is logged in without buyer details' do
      login_fm_buyer

      it 'renders the index page' do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context 'when the user is not logged in with buyer details' do
      login_fm_buyer_with_details

      it 'renders the index page' do
        get :index
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'validate service' do
    context 'when the service is not a valid service' do
      let(:default_params) { { service: 'apprenticeships', framework: 'RM6232' } }

      it 'renders the erros_not_found page' do
        get :index

        expect(response).to redirect_to errors_404_path
      end
    end
  end
end
