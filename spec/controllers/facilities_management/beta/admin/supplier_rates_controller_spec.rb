require 'rails_helper'

RSpec.describe FacilitiesManagement::Beta::Admin::SupplierRatesController do
  describe 'GET #supplier-benchmark-rates' do
    it 'returns http success' do
      get :supplier_benchmark_rates
      expect(response).to have_http_status(:found)
    end
  end

  describe 'GET #supplier-framework-rates' do
    it 'returns http success' do
      get :supplier_framework_rates
      expect(response).to have_http_status(:found)
    end
  end

  describe 'PUT update_supplier_framework_rates' do
    login_admin_buyer
    let(:rates) { FacilitiesManagement::Admin::Rates.limit(3) }

    before do
      put :update_supplier_framework_rates, params: { rates: values }
    end

    context 'with all valid' do
      let(:values) do
        {
          rates[0].id => 0.1,
          rates[1].id => 1.1,
          rates[2].id => 2.1
        }
      end

      it 'updates rates' do
        expect(rates[0].reload.framework).to eq values[values.keys[0]]
        expect(rates[1].reload.framework).to eq values[values.keys[1]]
        expect(rates[2].reload.framework).to eq values[values.keys[2]]
      end

      it 'redirects to the "RM3830 Administration dashboard" page' do
        expect(response).to redirect_to(facilities_management_beta_admin_path)
      end
    end

    context 'with some invalid' do
      let(:values) do
        {
          rates[0].id => 0.2,
          rates[1].id => 2,
          rates[2].id => 'crabsticks'
        }
      end

      it 'no records updated' do
        expect(rates[0].reload.framework).not_to eq values[values.keys[0]]
        expect(rates[1].reload.framework).not_to eq values[values.keys[1]]
        expect(rates[2].reload.framework).not_to eq values[values.keys[2]]
      end

      it 're-renders xxx' do
      end
    end
  end
end
