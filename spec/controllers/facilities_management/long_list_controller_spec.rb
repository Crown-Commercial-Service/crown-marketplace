require 'rails_helper'
RSpec.describe FacilitiesManagement::LongListController, type: :controller do
  describe 'GET #long_list' do
    it 'returns http success' do
      get :long_list
      expect(response).to have_http_status(:found)
    end
  end
end
