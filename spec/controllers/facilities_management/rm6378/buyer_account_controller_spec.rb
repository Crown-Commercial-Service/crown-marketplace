require 'rails_helper'
RSpec.describe FacilitiesManagement::RM6378::BuyerAccountController do
  let(:default_params) { { service: 'facilities_management', framework: framework } }
  let(:framework) { 'RM6378' }

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:found)
    end

    context 'when logged in with buyer details' do
      login_fm_buyer_with_details

      it 'is expected to not be nil' do
        get :index

        expect(assigns(:buyer_detail)).not_to be_nil
      end

      it 'is expected to have an email address' do
        get :index

        expect(assigns(:current_login_email)).not_to be_nil
      end
    end

    context 'when logged in without buyer details' do
      login_fm_buyer

      it 'is expected to redirect to edit_facilities_management_buyer_detail_path' do
        get :index

        expect(response).to redirect_to edit_facilities_management_buyer_detail_path(framework, controller.current_user.buyer_detail)
      end
    end

    context 'when not logged in' do
      it 'is expected to be nil' do
        expect(assigns(:buyer_detail)).to be_nil
      end

      it 'is expected to not have an email address' do
        expect(assigns(:current_login_email)).to be_nil
      end
    end

    context 'when the framework is not recognised' do
      let(:framework) { 'RM9812' }

      login_fm_buyer_with_details

      before { get :index }

      it 'renders the unrecognised framework page with the right http status' do
        expect(response).to render_template('home/unrecognised_framework')
        expect(response).to have_http_status(:bad_request)
      end

      it 'sets the framework variables' do
        expect(assigns(:unrecognised_framework)).to eq 'RM9812'
        expect(controller.params[:framework]).to eq Framework.facilities_management.current_framework
      end
    end
  end
end
