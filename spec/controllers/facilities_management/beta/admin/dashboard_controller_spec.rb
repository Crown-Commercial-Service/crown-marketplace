require 'rails_helper'

RSpec.describe FacilitiesManagement::Beta::Admin::DashboardController do
  describe 'GET index' do
    context 'when new login' do
      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
