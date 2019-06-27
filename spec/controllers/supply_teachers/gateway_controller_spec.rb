require 'rails_helper'

RSpec.describe SupplyTeachers::GatewayController, type: :controller do
  describe 'GET index' do
    context 'when not signed in' do
      it 'renders the gateway page' do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context 'when signed in' do
      login_st_buyer
      it 'redirects to the framework start page' do
        get :index
        expect(response).to redirect_to(supply_teachers_path)
      end
    end
  end
end
