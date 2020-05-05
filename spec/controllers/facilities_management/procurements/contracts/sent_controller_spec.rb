require 'rails_helper'

RSpec.describe FacilitiesManagement::Procurements::Contracts::SentController, type: :controller do
  login_fm_buyer_with_details

  let(:procurement) { create(:facilities_management_procurement, user: User.first) }
  let(:supplier) { create(:ccs_fm_supplier) }
  let(:contract) { create(:facilities_management_procurement_supplier_da, procurement: procurement, supplier_id: supplier.id) }

  describe 'GET index' do
    context 'when user enter a url for a contract that the user has sent' do
      it 'renders the correct template' do
        get :index, params: { procurement_id: contract.procurement.id, contract_id: contract.id }

        expect(response).to render_template('index')
      end
    end
  end
end
