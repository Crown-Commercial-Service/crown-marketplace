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
end
