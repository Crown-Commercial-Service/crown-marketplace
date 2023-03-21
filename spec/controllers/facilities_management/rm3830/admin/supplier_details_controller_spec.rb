require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Admin::SupplierDetailsController do
  let(:default_params) { { service: 'facilities_management/admin', framework: 'RM3830' } }
  let(:supplier) { FacilitiesManagement::RM3830::Admin::SuppliersAdmin.find_by(supplier_name: 'Abernathy and Sons') }

  login_fm_admin

  describe 'GET index' do
    context 'when an fm amdin' do
      before { get :index }

      it 'renders the index page' do
        expect(response).to render_template(:index)
      end

      it 'sets the list of suppliers' do
        expect(assigns(:suppliers).size).to eq FacilitiesManagement::RM3830::Admin::SuppliersAdmin.count
      end
    end

    context 'when not an fm admin' do
      login_fm_buyer

      before { get :index }

      it 'redirects to not permitted page' do
        expect(response).to redirect_to '/facilities-management/RM3830/admin/not-permitted'
      end
    end
  end
end
