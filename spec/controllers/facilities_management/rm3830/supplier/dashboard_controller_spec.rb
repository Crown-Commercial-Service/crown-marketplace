require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Supplier::DashboardController do
  let(:default_params) { { service: 'facilities_management/supplier', framework: 'RM3830' } }

  describe '#index' do
    login_fm_supplier

    let(:supplier) { create(:facilities_management_rm3830_supplier_detail) }

    let!(:received) { create(:facilities_management_rm3830_procurement_supplier_da, supplier_id: supplier.supplier_id, aasm_state: 'sent') }
    let!(:accepted) { create(:facilities_management_rm3830_procurement_supplier_da, supplier_id: supplier.supplier_id, aasm_state: 'accepted') }
    let!(:live) { create(:facilities_management_rm3830_procurement_supplier_da, supplier_id: supplier.supplier_id, aasm_state: 'signed') }
    let!(:closed) { create(:facilities_management_rm3830_procurement_supplier_da, supplier_id: supplier.supplier_id, aasm_state: 'declined') }

    context 'with supplier not found' do
      before { get :index }

      # rubocop:disable RSpec/MultipleExpectations
      it 'assigns blanks to offers and contracts' do
        expect(assigns(:received_offers)).to be_empty
        expect(assigns(:accepted_offers)).to be_empty
        expect(assigns(:live_contracts)).to be_empty
        expect(assigns(:closed_contracts)).to be_empty
      end
      # rubocop:enable RSpec/MultipleExpectations
    end

    context 'with supplier found' do
      before do
        supplier.update(user: controller.current_user)
        get :index
      end

      # rubocop:disable RSpec/MultipleExpectations
      it 'assigns correct offers and contracts' do
        expect(assigns(:received_offers)).to eq([received])
        expect(assigns(:accepted_offers)).to eq([accepted])
        expect(assigns(:live_contracts)).to eq([live])
        expect(assigns(:closed_contracts)).to eq([closed])
      end
      # rubocop:enable RSpec/MultipleExpectations
    end

    context 'when the framework is not recognised' do
      let(:default_params) { { service: 'facilities_management/supplier', framework: '↑↑↓↓←→←→BA' } }

      login_fm_supplier

      before { get :index }

      it 'renders the unrecognised framework page with the right http status' do
        expect(response).to render_template('home/unrecognised_framework')
        expect(response).to have_http_status(:bad_request)
      end

      it 'sets the framework variables' do
        expect(assigns(:unrecognised_framework)).to eq '↑↑↓↓←→←→BA'
        expect(controller.params[:framework]).to eq FacilitiesManagement::Framework.default_framework
      end
    end
  end
end
