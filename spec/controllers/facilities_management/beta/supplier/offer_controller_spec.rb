require 'rails_helper'

RSpec.describe FacilitiesManagement::Beta::Supplier::OfferController do
  describe 'GET #declined' do
    it 'returns http success' do
      get :declined
      expect(response).to have_http_status(:found)
    end
  end
end
