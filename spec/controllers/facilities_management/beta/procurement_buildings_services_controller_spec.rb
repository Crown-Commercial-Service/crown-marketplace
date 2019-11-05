require 'rails_helper'

RSpec.describe FacilitiesManagement::Beta::ProcurementBuildingsServicesController, type: :controller do
  describe 'GET #edit' do
    it 'returns http success' do
      get :show, params: { id: 9897987 }
      expect(response).to have_http_status(:redirect)
    end
  end
end
