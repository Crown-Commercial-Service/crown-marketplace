require 'rails_helper'

RSpec.describe FacilitiesManagement::Supplier::DashboardController, type: :controller do
  describe '#index' do
    login_fm_supplier

    let(:supplier) { create(:ccs_fm_supplier) }

    let!(:received) { create(:facilities_management_procurement_supplier_da, supplier_id: supplier.id, aasm_state: 'sent') }
    let!(:accepted) { create(:facilities_management_procurement_supplier_da, supplier_id: supplier.id, aasm_state: 'accepted') }
    let!(:live) { create(:facilities_management_procurement_supplier_da, supplier_id: supplier.id, aasm_state: 'signed') }
    let!(:closed) { create(:facilities_management_procurement_supplier_da, supplier_id: supplier.id, aasm_state: 'declined') }

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
        supplier.update(contact_email: controller.current_user.email)
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
  end
end
