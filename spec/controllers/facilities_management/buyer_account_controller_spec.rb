require 'rails_helper'
RSpec.describe FacilitiesManagement::BuyerAccountController, type: :controller do
  describe 'GET #buyer_account' do
    it 'returns http success' do
      get :buyer_account
      expect(response).to have_http_status(:found)
    end
  end
end
