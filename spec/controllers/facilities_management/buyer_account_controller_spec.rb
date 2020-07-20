require 'rails_helper'
module FacilitiesManagement
  RSpec.describe BuyerAccountController, type: :controller do
    describe 'GET #buyer_account' do
      it 'returns http success' do
        get :buyer_account
        expect(response).to have_http_status(:found)
      end
    end
  end
end
