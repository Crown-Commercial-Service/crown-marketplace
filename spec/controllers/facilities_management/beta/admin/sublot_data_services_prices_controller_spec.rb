require 'rails_helper'

RSpec.describe FacilitiesManagement::Beta::Admin::SublotDataServicesPricesController, type: :controller do
  login_admin_buyer

  describe 'GET index' do
    context 'when index page is rendered' do
      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:ok)
      end

      it 'renders the index page' do
        get :index
        expect(response).to render_template(:index)
      end

      xit 'retrieves correct data' do
        # get :index
        # array_size = assigns(@list_service_types).size
        # expect(array_size).to == 10
      end
    end
  end
end
