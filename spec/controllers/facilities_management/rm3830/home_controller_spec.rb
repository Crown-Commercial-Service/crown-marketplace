require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::HomeController, type: :controller do
  let(:default_params) { { service: 'facilities_management', framework: 'RM3830' } }

  describe 'GET index' do
    context 'when the user is not logged in' do
      it 'renders the index page' do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context 'when the user is logged in without buyer details' do
      login_fm_buyer

      it 'renders the index page' do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context 'when the user is not logged in with buyer details' do
      login_fm_buyer_with_details

      it 'renders the index page' do
        get :index
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'validate service' do
    context 'when the service is not a valid service' do
      let(:default_params) { { service: 'apprenticeships', framework: 'RM3830' } }

      it 'renders the erros_not_found page' do
        get :index

        expect(response).to redirect_to errors_404_path
      end
    end
  end
end
