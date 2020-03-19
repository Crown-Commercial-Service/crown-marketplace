require 'rails_helper'

RSpec.describe FacilitiesManagement::Beta::Admin::SublotDataServicesPricesController, type: :controller do
  login_admin_buyer

  describe 'GET index' do
    context 'when index page is rendered' do
      it 'returns http success' do
        get :index, params: { id: 'ca57bf4c-e8a5-468a-95f4-39fcf730c770' }
        expect(response).to have_http_status(:ok)
      end

      it 'returns http redirect for invalid id' do
        get :index, params: { id: '124' }
        expect(response).to have_http_status(:found)
      end

      it 'renders the index page' do
        get :index, params: { id: 'ca57bf4c-e8a5-468a-95f4-39fcf730c770' }
        expect(response).to render_template(:index)
      end

      it 'retrieves correct list and name data' do
        get :index, params: { id: 'ca57bf4c-e8a5-468a-95f4-39fcf730c770' }
        expect(assigns(:list_service_types).size).to eq 13
        expect(assigns(:supplier_name)).to eq 'Abernathy and Sons'
      end

      it 'retrieves correct data' do
        get :index, params: { id: 'ca57bf4c-e8a5-468a-95f4-39fcf730c770' }
        expect(assigns(:supplier_rate_data_checkboxes).size).to eq 116
        expect(assigns(:supplier_data_ratecard_prices).size).to eq 1
        expect(assigns(:supplier_data_ratecard_discounts).size).to eq 1
      end
    end
  end
end
