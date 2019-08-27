require 'rails_helper'

RSpec.describe FacilitiesManagement::Beta::BuildingsManagementController do
  describe 'GET #buildings_management' do
    it 'returns http success' do
      get :buildings_management
      expect(response).to have_http_status(:found)
    end
  end

  describe 'GET #building' do
    it 'returns http success' do
      get :building
      expect(response).to have_http_status(:ok)
    end
  end
end
