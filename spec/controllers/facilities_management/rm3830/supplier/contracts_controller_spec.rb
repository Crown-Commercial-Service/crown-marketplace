require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Supplier::ContractsController do
  let(:default_params) { { service: 'facilities_management/supplier', framework: 'RM3830' } }

  describe 'PUT update' do
    let(:user) { create(:user, :with_detail, confirmed_at: Time.zone.now, roles: %i[supplier fm_access]) }
    let(:procurement) { create(:facilities_management_rm3830_procurement_with_contact_details, user:) }
    let(:contract) { create(:facilities_management_rm3830_procurement_supplier_da_with_supplier, facilities_management_rm3830_procurement_id: procurement.id, aasm_state: 'sent', offer_sent_date: Time.zone.now, supplier: supplier) }
    let(:supplier) { create(:facilities_management_rm3830_supplier_detail, user: controller.current_user) }

    login_fm_supplier

    before do
      allow(FacilitiesManagement::RM3830::SupplierDetail).to receive(:find).and_return(supplier)
      allow(FacilitiesManagement::GovNotifyNotification).to receive(:perform_async).and_return(nil)
    end

    context 'when the supplier accepts the procurement' do
      before do
        allow(FacilitiesManagement::RM3830::AwaitingSignatureReminder).to receive(:perform_at).and_return(nil)
        put :update, params: { procurement_id: procurement.id, id: contract.id, facilities_management_rm3830_procurement_supplier: { contract_response: true } }
      end

      it 'redirects to facilities_management_rm3830_supplier_contract_sent_index_path' do
        expect(response).to redirect_to facilities_management_rm3830_supplier_contract_sent_index_path(contract.id)
      end

      it 'updates the state of the contract to accepted' do
        contract.reload

        expect(contract.accepted?).to be true
      end
    end

    context 'when the supplier declines the procurement' do
      context 'when supplier adds a valid reason' do
        let(:reason_for_declining) { 'Can not provide the service' }

        before do
          put :update, params: { procurement_id: procurement.id, id: contract.id, facilities_management_rm3830_procurement_supplier: { contract_response: false, reason_for_declining: reason_for_declining } }
        end

        it 'redirects to facilities_management_rm3830_supplier_contract_sent_index_path' do
          expect(response).to redirect_to facilities_management_rm3830_supplier_contract_sent_index_path(contract.id)
        end

        it 'updates the state of the contract to declined' do
          contract.reload

          expect(contract.declined?).to be true
        end

        it 'updates the reason for declining' do
          contract.reload

          expect(contract.reason_for_declining).to eq reason_for_declining
        end
      end

      context 'when the supplier does not add a valid reason' do
        it 'renders the edit template' do
          put :update, params: { procurement_id: procurement.id, id: contract.id, facilities_management_rm3830_procurement_supplier: { contract_response: false, reason_for_declining: '' } }

          expect(response).to render_template('edit')
        end
      end
    end
  end

  describe '.authorize_user' do
    let(:contract) { create(:facilities_management_rm3830_procurement_supplier, supplier:) }
    let(:procurement) { create(:facilities_management_rm3830_procurement, user:) }
    let(:user) { create(:user, :without_detail, confirmed_at: Time.zone.now, roles: %i[supplier fm_access]) }
    let(:wrong_user) { create(:user, :without_detail, confirmed_at: Time.zone.now, roles: %i[supplier fm_access]) }
    let(:supplier) { create(:facilities_management_rm3830_supplier_detail, user:) }

    before do
      allow(FacilitiesManagement::RM3830::SupplierDetail).to receive(:find).and_return(supplier)
    end

    context 'when the user is not the intended supplier' do
      before { sign_in wrong_user }

      it 'will not be able to manage the contract' do
        ability = Ability.new(wrong_user)

        expect(ability.cannot?(:manage, contract)).to be true
      end

      it 'redirects to the not permited page' do
        get :show, params: { procurement_id: procurement.id, id: contract.id }

        expect(response).to redirect_to '/facilities-management/RM3830/supplier/not-permitted'
      end
    end

    context 'when the user is the intended supplier' do
      before { sign_in user }

      it 'will be able to manage the contract' do
        ability = Ability.new(user)

        expect(ability.can?(:manage, contract)).to be true
      end

      it 'renders the show page' do
        get :show, params: { procurement_id: procurement.id, id: contract.id }

        expect(response).to render_template('show')
      end
    end
  end

  describe 'GET edit' do
    let(:procurement) { create(:facilities_management_rm3830_procurement, user: create(:user)) }
    let(:contract) { create(:facilities_management_rm3830_procurement_supplier_da_with_supplier, procurement: procurement, aasm_state: state, supplier: supplier) }
    let(:supplier) { create(:facilities_management_rm3830_supplier_detail, user: controller.current_user) }

    login_fm_supplier

    before do
      controller.current_user.email = contract.supplier.contact_email
      get :edit, params: { id: contract.id }
    end

    context 'when the contract is sent' do
      let(:state) { 'sent' }

      it 'renders the edit page' do
        expect(response).to render_template(:edit)
      end
    end

    context 'when the contract is accepted' do
      let(:state) { 'accepted' }

      it 'redirects to the contract summary' do
        expect(response).to redirect_to facilities_management_rm3830_supplier_contract_path(id: contract.id)
      end
    end

    context 'when the contract is signed' do
      let(:state) { 'signed' }

      it 'redirects to the contract summary' do
        expect(response).to redirect_to facilities_management_rm3830_supplier_contract_path(id: contract.id)
      end
    end

    context 'when the contract is not_signed' do
      let(:state) { 'not_signed' }

      it 'redirects to the contract summary' do
        expect(response).to redirect_to facilities_management_rm3830_supplier_contract_path(id: contract.id)
      end
    end

    context 'when the contract is declined' do
      let(:state) { 'declined' }

      it 'redirects to the contract summary' do
        expect(response).to redirect_to facilities_management_rm3830_supplier_contract_path(id: contract.id)
      end
    end

    context 'when the contract is expired' do
      let(:state) { 'expired' }

      it 'redirects to the contract summary' do
        expect(response).to redirect_to facilities_management_rm3830_supplier_contract_path(id: contract.id)
      end
    end

    context 'when the contract is withdrawn' do
      let(:state) { 'withdrawn' }

      it 'redirects to the contract summary' do
        expect(response).to redirect_to facilities_management_rm3830_supplier_contract_path(id: contract.id)
      end
    end
  end
end
