require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Admin::SupplierLotDataController, type: :controller do
  let(:default_params) { { service: 'facilities_management/admin', framework: 'RM6232' } }

  login_fm_admin

  describe 'GET #show' do
    let(:supplier) { FacilitiesManagement::RM6232::Supplier.order(:supplier_name).sample }

    context 'when logged in as an fm admin' do
      before { get :show, params: { id: supplier.id } }

      it 'renders the show page' do
        expect(response).to render_template(:show)
      end

      it 'assigns the supplier' do
        expect(assigns(:supplier)).to eq supplier
      end

      it 'assigns the lot data' do
        expect(assigns(:lot_data).map { |lot_data| lot_data[:id] }).to eq supplier.lot_data.order(:lot_code).pluck(:id)
      end
    end

    context 'when not logged in as an fm admin' do
      login_fm_buyer

      it 'redirects to not permitted page' do
        get :show, params: { id: supplier.id }
        expect(response).to redirect_to not_permitted_path(service: 'facilities_management')
      end
    end
  end
end
