require 'rails_helper'
RSpec.describe FacilitiesManagement::BuildingsController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:found)
    end
  end
end
