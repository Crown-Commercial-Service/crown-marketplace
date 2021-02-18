require 'rails_helper'

RSpec.describe FacilitiesManagement::Admin::AdminAccountController do
  describe 'GET #index' do
    context 'when logged in as fm admin' do
      login_fm_admin

      before { get :index }

      it 'renders the index page' do
        expect(response).to render_template(:index)
      end
    end

    context 'when not logged in as fm admin' do
      login_fm_buyer

      before { get :index }

      it 'redirects to the not permitted page' do
        expect(response).to redirect_to not_permitted_path(service: 'facilities_management')
      end
    end
  end
end
