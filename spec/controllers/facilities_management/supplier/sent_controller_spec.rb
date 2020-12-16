require 'rails_helper'

RSpec.describe FacilitiesManagement::Supplier::SentController, type: :controller do
  describe '#index' do
    subject(:index) { get :index, params: { contract_id: contract.id } }

    let(:supplier) { create(:facilities_management_supplier_detail) }
    let(:contract) { create(:facilities_management_procurement_supplier_da, supplier_id: supplier.id, aasm_state: 'signed') }

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
      it 'redirects to FM gateway' do
        expect(index).to redirect_to('/facilities-management/gateway')
      end
    end
  end
end
