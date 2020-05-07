require 'rails_helper'

RSpec.describe FacilitiesManagement::Admin::GatewayController, type: :controller do
  describe 'GET index' do
    context 'when not signed in' do
      it 'renders the gateway page' do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context 'when signed in' do
      login_admin_buyer
      it 'redirects to the framework admin start page' do
        get :index
        expect(response).to redirect_to(facilities_management_admin_path)
      end
    end
  end
end
