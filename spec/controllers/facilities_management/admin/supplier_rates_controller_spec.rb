require 'rails_helper'

RSpec.describe FacilitiesManagement::Admin::SupplierRatesController do
  describe 'GET supplier-benchmark-rates' do
    it 'returns http success' do
      get :supplier_benchmark_rates
      expect(response).to have_http_status(:found)
    end
  end

  describe 'GET supplier-framework-rates' do
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
        expect(response).to redirect_to(facilities_management_admin_path)
      end

      it 'displays no error summary' do
        expect(assigns(:errors)).to be_empty
      end

      it 'displays success message' do
        expect(flash[:success]).to be_present
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

      it 'displays error summary' do
        expect(assigns(:errors)).not_to be_empty
      end

      it 'displays no success message' do
        expect(flash[:success]).not_to be_present
      end
    end
  end

  describe 'PUT update_supplier_benchmark_rates' do
    login_admin_buyer
    let(:rates) { FacilitiesManagement::Admin::Rates.limit(3) }

    before do
      put :update_supplier_benchmark_rates, params: { rates: values }
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
        expect(rates[0].reload.benchmark).to eq values[values.keys[0]]
        expect(rates[1].reload.benchmark).to eq values[values.keys[1]]
        expect(rates[2].reload.benchmark).to eq values[values.keys[2]]
      end

      it 'redirects to the "RM3830 Administration dashboard" page' do
        expect(response).to redirect_to(facilities_management_admin_path)
      end

      it 'displays no error summary' do
        expect(assigns(:errors)).to be_empty
      end

      it 'displays success message' do
        expect(flash[:success]).to be_present
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
        expect(rates[0].reload.benchmark).not_to eq values[values.keys[0]]
        expect(rates[1].reload.benchmark).not_to eq values[values.keys[1]]
        expect(rates[2].reload.benchmark).not_to eq values[values.keys[2]]
      end

      it 'displays error summary' do
        expect(assigns(:errors)).not_to be_empty
      end

      it 'displays no success message' do
        expect(flash[:success]).not_to be_present
      end
    end
  end
end
