require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Supplier::SentController do
  let(:default_params) { { service: 'facilities_management/supplier', framework: 'RM3830' } }

  describe '#index' do
    subject(:index) { get :index, params: { contract_id: contract.id } }

    let(:supplier) { create(:facilities_management_rm3830_supplier_detail, user: controller.current_user) }
    let(:contract) { create(:facilities_management_rm3830_procurement_supplier_da, supplier: supplier, aasm_state: 'signed') }

    context 'when signed in' do
      login_fm_supplier

      before do
        supplier.update(contact_email: controller.current_user.email)
      end

      it 'assigns contract' do
        index
        expect(assigns(:contract)).to eq(contract)
      end

      it 'renders index template' do
        expect(index).to render_template(:index)
      end
    end

    context 'when not signed in' do
      it 'redirects to FM sign-in' do
        expect(index).to redirect_to facilities_management_rm3830_supplier_new_user_session_path
      end
    end
  end
end
