require 'rails_helper'
module FacilitiesManagement
  RSpec.describe BuyerAccountController, type: :controller do
    describe 'GET #buyer_account' do
      it 'returns http success' do
        get :buyer_account
        expect(response).to have_http_status(:found)
      end

      context 'when logged in' do
        login_fm_buyer_with_details

        it 'is expected to not be nil' do
          get :buyer_account

          expect(assigns(:buyer_detail)).not_to be_nil
        end

        it 'is expected to have an email address' do
          get :buyer_account

          expect(assigns(:current_login_email)).not_to be_nil
        end
      end

      context 'when not logged in' do
        it 'is expected to be nil' do
          expect(assigns(:buyer_detail)).to be_nil
        end

        it 'is expected to not have an email address' do
          expect(assigns(:current_login_email)).to be_nil
        end
      end
    end
  end
end
