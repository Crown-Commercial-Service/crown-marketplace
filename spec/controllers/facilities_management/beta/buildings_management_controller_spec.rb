require 'rails_helper'

RSpec.describe FacilitiesManagement::Beta::BuildingsManagementController do
  describe 'GET index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:found)
    end
  end
end
