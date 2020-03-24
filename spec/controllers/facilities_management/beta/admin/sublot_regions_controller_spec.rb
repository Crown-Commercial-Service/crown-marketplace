require 'rails_helper'

RSpec.describe FacilitiesManagement::Beta::Admin::SublotRegionsController do
  login_admin_buyer
  describe 'GET #get_sublot_regions_one_a' do
    context 'when sublot_region_one_a page is rendered' do
      it 'returns http success' do
        get :sublot_region_one_a, params: { id: 'ca57bf4c-e8a5-468a-95f4-39fcf730c770' }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
