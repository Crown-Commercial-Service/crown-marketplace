require 'rails_helper'
RSpec.describe FacilitiesManagement::SelectServicesController, type: :controller do
  describe 'GET #select_services' do
    it 'returns http success' do
      get :select_services
      expect(response).to have_http_status(:success)
    end
  end
end
