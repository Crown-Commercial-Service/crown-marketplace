require 'rails_helper'
module FacilitiesManagement
  RSpec.describe Beta::BuyerAccountController, type: :controller do
    describe 'GET #buyer_account' do
      it 'returns http success' do
        get :buyer_account
        expect(response).to have_http_status(:found)
      end
    end

    describe 'GET #buyer_details' do
      it 'returns http success' do
        get :buyer_details
        expect(response).to have_http_status(:found)
      end
    end
  end
end
