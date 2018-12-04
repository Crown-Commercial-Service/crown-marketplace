require 'rails_helper'

RSpec.describe FacilitiesManagement::GatewayController, type: :controller do
  describe 'GET index' do
    context 'when not signed in' do
      before do
        ensure_not_logged_in
      end

      it 'renders the gateway page' do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context 'when signed in' do
      before do
        ensure_logged_in
      end

      it 'redirects to the framework start page' do
        get :index
        expect(response).to redirect_to(facilities_management_path)
      end
    end
  end
end
