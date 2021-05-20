require 'rails_helper'

RSpec.describe FacilitiesManagement::Supplier::HomeController, type: :controller do
  let(:default_params) { { service: 'facilities_management/supplier' } }

  describe '#index' do
    subject(:index) { get :index }

    context 'when signed in' do
      login_fm_supplier

      it 'redirects to supplier dashboard' do
        expect(index).to redirect_to(facilities_management_supplier_dashboard_index_path)
      end
    end

    context 'when not signed in' do
      it 'redirects to supplier sign in' do
        expect(index).to redirect_to(facilities_management_supplier_new_user_session_path)
      end
    end
  end

  describe 'GET accessibility_statement' do
    login_fm_supplier

    it 'renders the accessibility_statement page' do
      get :accessibility_statement
      expect(response).to render_template('home/accessibility_statement')
    end
  end

  describe 'GET cookie_policy' do
    login_fm_supplier

    it 'renders the cookie policy page' do
      get :cookie_policy
      expect(response).to render_template('home/cookie_policy')
    end
  end

  describe 'GET cookie_settings' do
    login_fm_supplier

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
