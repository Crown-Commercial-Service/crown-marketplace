require 'rails_helper'

RSpec.describe FacilitiesManagement::Beta::Admin::SublotRegionsController do
  login_admin_buyer
  describe 'GET #get_sublot_regions' do
    context 'when sublot_region page is rendered' do
      it 'returns http success' do
        get :sublot_region, params: { id: 'ca57bf4c-e8a5-468a-95f4-39fcf730c770', lot_type: '1a' }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
