require 'rails_helper'

RSpec.describe FacilitiesManagement::GatewayController, type: :controller do
  let(:default_params) { { service: 'facilities_management' } }

  describe 'GET index' do
    context 'when not signed in' do
      it 'renders the gateway page' do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context 'when signed in without details' do
      login_fm_buyer

      it 'redirects to the framework start page' do
        get :index
        expect(response).to redirect_to edit_facilities_management_buyer_detail_path(controller.current_user.buyer_detail)
      end
    end

    context 'when signed in with details' do
      login_fm_buyer_with_details

      it 'redirects to the framework start page' do
        get :index
        expect(response).to redirect_to(facilities_management_path)
      end
    end
  end
end
