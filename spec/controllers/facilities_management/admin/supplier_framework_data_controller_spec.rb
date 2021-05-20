require 'rails_helper'

RSpec.describe FacilitiesManagement::Admin::SupplierFrameworkDataController, type: :controller do
  let(:default_params) { { service: 'facilities_management/admin' } }

  login_fm_admin

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    context 'when not an fm admin' do
      login_fm_buyer

      it 'redirects to not permitted page' do
        get :index
        expect(response).to redirect_to not_permitted_path(service: 'facilities_management')
      end
    end
  end

  describe 'verify data' do
    it 'returns if to show lot section' do
      get :index
      expect(assigns(:supplier_lot1a_present)['Abernathy and Sons']).to eq true
      expect(assigns(:supplier_lot1b_present)['Abernathy and Sons']).to eq true
      expect(assigns(:supplier_lot1c_present)['Abernathy and Sons']).to eq nil
    end
  end
end
