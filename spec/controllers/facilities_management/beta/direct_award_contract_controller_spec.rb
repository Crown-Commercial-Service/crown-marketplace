require 'rails_helper'

RSpec.describe FacilitiesManagement::Beta::DirectAwardContractController do
  describe 'GET #sending_the_contract' do
    it 'returns http success' do
      get :sending_the_contract
      expect(response).to have_http_status(:found)
    end
  end
end
