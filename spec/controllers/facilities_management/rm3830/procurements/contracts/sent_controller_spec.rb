require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Procurements::Contracts::SentController do
  let(:default_params) { { service: 'facilities_management', framework: framework } }
  let(:framework) { 'RM3830' }
  let(:procurement) { create(:facilities_management_rm3830_procurement, user: subject.current_user) }
  let(:supplier) { create(:facilities_management_rm3830_supplier_detail) }
  let(:contract) { create(:facilities_management_rm3830_procurement_supplier_da, procurement: procurement, supplier_id: supplier.id) }

  login_fm_buyer_with_details

  describe 'GET index' do
    context 'when user enter a url for a contract that the user has sent' do
      it 'renders the correct template' do
        get :index, params: { procurement_id: contract.procurement.id, contract_id: contract.id }

        expect(response).to render_template('index')
      end
    end

    context 'when logging in with a different user than the one that created the procurement' do
      it 'redirects to the not permitted page' do
        procurement.update(user: create(:user))
        get :index, params: { procurement_id: contract.procurement.id, contract_id: contract.id }

        expect(response).to redirect_to '/facilities-management/RM3830/not-permitted'
      end
    end

    context 'when logging in without buyer details' do
      login_fm_buyer

      it 'is expected to redirect to edit_facilities_management_buyer_detail_path' do
        get :index, params: { procurement_id: procurement.id, contract_id: contract.id }

        expect(response).to redirect_to edit_facilities_management_buyer_detail_path(framework, controller.current_user.buyer_detail)
      end
    end
  end
end
