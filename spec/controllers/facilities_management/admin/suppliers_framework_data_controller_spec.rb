require 'rails_helper'

RSpec.describe FacilitiesManagement::Admin::SuppliersFrameworkDataController do
  login_admin_buyer

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'verify data' do
    it 'returns if to show lot section' do
      get :index
      expect(assigns(:supplier_lot1a_present)['Abernathy and Sons']).to eq true
      expect(assigns(:supplier_lot1b_present)['Abernathy and Sons']).to eq true
      expect(assigns(:supplier_lot1c_present)['Abernathy and Sons']).to eq false
    end
  end
end
