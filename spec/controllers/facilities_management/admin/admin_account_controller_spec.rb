require 'rails_helper'

RSpec.describe FacilitiesManagement::Admin::AdminAccountController do
  describe 'GET #admin_account' do
    it 'returns http success' do
      get :admin_account
      expect(response).to have_http_status(:found)
    end
  end
end
