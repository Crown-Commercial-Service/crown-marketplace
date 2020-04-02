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

  describe 'PUT update_rates for variance' do
    it '#update_sublot_data_services_price' do
      put :update_sublot_data_services_prices, params: { id: 'ca57bf4c-e8a5-468a-95f4-39fcf730c770', 'rate[M.142]': 1.123456, 'checked_services': 'C.1', 'data[C.1][ABC]': 1 }

      rate_card = CCS::FM::RateCard.latest
      supplier_name = 'Abernathy and Sons'
      supplier_rate_card = rate_card['data'][:Variances].select do |k, v|
        v if k.to_s == supplier_name
      end
      variance_supplier_data = supplier_rate_card[supplier_name.to_sym]
      expect(variance_supplier_data['Profit %'.to_sym]).to eq 1.123456
    end

    it 'redirects correctly' do
      put :update_sublot_data_services_prices, params: { id: 'ca57bf4c-e8a5-468a-95f4-39fcf730c770', 'rate[M.141]': 1.123, 'checked_services': 'C.1', 'data[C.1][ABC]': 1 }
      expect(response).to redirect_to(facilities_management_beta_admin_supplier_framework_data_path)
    end
  end

  describe 'PUT update_rates for checkbox' do
    it 'updates checkbox' do
      put :update_sublot_data_services_prices, params: { id: 'ca57bf4c-e8a5-468a-95f4-39fcf730c770', 'rate[M.141]': 1.123, 'checked_services': 'C.1', 'data[C.1][ABC]': 1 }

      supplier = FacilitiesManagement::Admin::SuppliersAdmin.find('ca57bf4c-e8a5-468a-95f4-39fcf730c770')
      supplier_data = supplier['data']
      lot1a_data = supplier_data['lots'].select { |data| data['lot_number'] == '1a' }
      supplier_services = lot1a_data[0]['services']

      expect(supplier_services.include?('C.1')).to eq true
    end
  end

  describe 'PUT update_rates for data table' do
    it 'updates data table for prices' do
      put :update_sublot_data_services_prices, params: { id: 'ca57bf4c-e8a5-468a-95f4-39fcf730c770', 'rate[M.141]': 1.123, 'checked_services': 'C.1', 'data[C.1][Call Centre Operations (£)]': 5.19 }

      supplier_data = FacilitiesManagement::Admin::SuppliersAdmin.find('ca57bf4c-e8a5-468a-95f4-39fcf730c770')['data']
      supplier_name = supplier_data['supplier_name']
      latest_rate_card = CCS::FM::RateCard.latest
      supplier_data_ratecard_prices = latest_rate_card[:data][:Prices].select { |key, _| supplier_name.include? key.to_s }
      supplier_data = supplier_data_ratecard_prices.values[0].deep_stringify_keys!

      expect(supplier_data['C.1']['Call Centre Operations']).to eq 5.19
    end

    it 'updates data table for discount' do
      put :update_sublot_data_services_prices, params: { id: 'ca57bf4c-e8a5-468a-95f4-39fcf730c770', 'rate[M.141]': 1.123, 'checked_services': 'C.1', 'data[C.1][Direct Award Discount (%)]': 1.00 }

      supplier_data = FacilitiesManagement::Admin::SuppliersAdmin.find('ca57bf4c-e8a5-468a-95f4-39fcf730c770')['data']
      supplier_name = supplier_data['supplier_name']
      latest_rate_card = CCS::FM::RateCard.latest
      supplier_data_ratecard_discounts = latest_rate_card[:data][:Discounts].select { |key, _| supplier_name.include? key.to_s }
      supplier_data = supplier_data_ratecard_discounts.values[0].deep_stringify_keys!

      expect(supplier_data['C.1']['Disc %']).to eq 1.00
    end
  end
end
