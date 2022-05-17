require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Admin::SupplierFrameworkDataController, type: :controller do
  let(:default_params) { { service: 'facilities_management/admin', framework: 'RM3830' } }

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
        expect(response).to redirect_to '/facilities-management/RM3830/admin/not-permitted'
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
