require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Admin::SupplierFrameworkDataController do
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

      # Abernathy and Sons
      supplier_id = 'ca57bf4c-e8a5-468a-95f4-39fcf730c770'

      expect(assigns(:supplier_present)['1a'][supplier_id]).to be true
      expect(assigns(:supplier_present)['1b'][supplier_id]).to be true
      expect(assigns(:supplier_present)['1c'][supplier_id]).to be_nil
    end
  end
end
