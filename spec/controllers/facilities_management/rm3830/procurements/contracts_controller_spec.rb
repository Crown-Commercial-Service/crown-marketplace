require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Procurements::ContractsController do
  extend APIRequestStubs

  let(:default_params) { { service: 'facilities_management', framework: framework } }
  let(:framework) { 'RM3830' }
  let(:procurement) { create(:facilities_management_rm3830_procurement_with_contact_details, user: subject.current_user) }
  let(:contract) { create(:facilities_management_rm3830_procurement_supplier_da_with_supplier, facilities_management_rm3830_procurement_id: procurement.id, reason_for_closing: 'Close this', aasm_state: 'sent', offer_sent_date: Time.zone.now,) }
  let(:user) { subject.current_user }
  let(:wrong_user) { create(:user, :without_detail, confirmed_at: Time.zone.now, roles: %i[buyer fm_access]) }
  let(:supplier) { create(:facilities_management_rm3830_supplier_detail) }

  describe 'PUT update' do
    login_fm_buyer_with_details

    before { allow(FacilitiesManagement::GovNotifyNotification).to receive(:perform_async).and_return(nil) }

    context 'when the buyer closes the procurement' do
      let(:first_contract) { procurement.procurement_suppliers.min_by(&:direct_award_value) }

      before do
        first_contract.update(aasm_state: 'declined')
        put :update, params: { procurement_id: procurement.id, id: first_contract.id, name: 'withdraw', facilities_management_rm3830_procurement_supplier: { reason_for_closing: reason_for_closing } }
      end

      context 'when a reason for closing is given' do
        let(:reason_for_closing) { 'Taking too long' }

        it 'redirects to facilities_management_rm3830_procurement_contract_closed_index_path' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_contract_closed_index_path(procurement.id, contract_id: first_contract.id)
        end

        it 'updates the reason for closing' do
          first_contract.reload

          expect(first_contract.reason_for_closing).to eq reason_for_closing
        end
      end

      context 'when a reason for closing is not given' do
        let(:reason_for_closing) { '' }

        it 'renders the edit page' do
          expect(response).to render_template('edit')
        end
      end
    end

    context 'when the buyer signs the procurement' do
      let(:start_date) { Time.now.in_time_zone('London') + 2.years }
      let(:end_date) { Time.now.in_time_zone('London') + 4.years }

      stub_bank_holiday_json

      before do
        contract.update(aasm_state: 'accepted', supplier_response_date: Time.now.in_time_zone('London'))
        put :update, params: { procurement_id: procurement.id, id: contract.id, name: 'signed', facilities_management_rm3830_procurement_supplier: { contract_signed: true, contract_start_date_dd: start_date.day.to_s, contract_start_date_mm: start_date.month.to_s, contract_start_date_yyyy: start_date.year.to_s, contract_end_date_dd: end_date.day.to_s, contract_end_date_mm: end_date.month.to_s, contract_end_date_yyyy: end_date_yyyy } }
      end

      context 'when the buyer gives a valid date' do
        let(:end_date_yyyy) { end_date.year.to_s }

        it 'redirects to facilities_management_rm3830_procurement_contract_closed_index_path' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_contract_closed_index_path(procurement.id, contract_id: contract.id)
        end

        it 'updates the dates' do
          contract.reload

          expect(contract.contract_start_date.strftime('%d/%m/%Y')).to eq start_date.strftime('%d/%m/%Y')
          expect(contract.contract_end_date.strftime('%d/%m/%Y')).to eq end_date.strftime('%d/%m/%Y')
        end

        it 'sets the contract state to signed' do
          contract.reload

          expect(contract.signed?).to be true
        end
      end

      context 'when the buyer does not give a valid date' do
        let(:end_date_yyyy) { nil }

        it 'renders the edit page' do
          expect(response).to render_template('edit')
        end
      end
    end

    context 'when the buyer does not sign the procurement' do
      stub_bank_holiday_json

      before do
        contract.update(aasm_state: 'accepted', supplier_response_date: Time.now.in_time_zone('London'))
        put :update, params: { procurement_id: procurement.id, id: contract.id, name: 'signed', facilities_management_rm3830_procurement_supplier: { contract_signed: false, reason_for_not_signing: reason_for_not_signing } }
      end

      context 'when the buyer gives a valid reason' do
        let(:reason_for_not_signing) { 'The supplier did not respond' }

        it 'redirects to facilities_management_rm3830_procurement_contract_closed_index_path' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_contract_path(procurement.id, contract.id)
        end

        it 'updates the dates' do
          contract.reload

          expect(contract.reason_for_not_signing).to eq reason_for_not_signing
        end

        it 'sets the contract state to not_signed' do
          contract.reload

          expect(contract.not_signed?).to be true
        end
      end

      context 'when the buyer does not give a valid reason' do
        let(:reason_for_not_signing) { nil }

        it 'renders the edit page' do
          expect(response).to render_template('edit')
        end
      end
    end

    context 'when there are no more suppliers' do
      let(:last_contract) { procurement.procurement_suppliers.max_by(&:direct_award_value) }

      before do
        procurement.procurement_suppliers.each do |ps|
          ps.update(aasm_state: 'declined')
        end
        put :update, params: { procurement_id: procurement.id, id: last_contract.id, name: 'next_supplier' }
      end

      it 'redirects to facilities_management_rm3830_procurement_contract_sent_index_path' do
        expect(response).to redirect_to facilities_management_rm3830_procurement_contract_sent_index_path(procurement.id, contract_id: last_contract.id)
      end

      it 'sets the procurement state to closed' do
        procurement.reload

        expect(procurement.closed?).to be true
      end
    end

    context 'when offering to the next supplier' do
      let(:first_contract) { procurement.procurement_suppliers.min_by(&:direct_award_value) }
      let(:next_contract) { procurement.procurement_suppliers.sort_by(&:direct_award_value)[1] }

      stub_bank_holiday_json

      before do
        first_contract.update(aasm_state: 'declined')
        next_contract.update(supplier_id: supplier.id)
        allow(FacilitiesManagement::RM3830::GenerateContractZip).to receive(:perform_in).and_return(nil)
        allow(FacilitiesManagement::RM3830::ChangeStateWorker).to receive(:perform_at).and_return(nil)
        allow(FacilitiesManagement::RM3830::ContractSentReminder).to receive(:perform_at).and_return(nil)
        put :update, params: { procurement_id: procurement.id, id: first_contract.id, name: 'next_supplier' }
      end

      it 'redirects to facilities_management_rm3830_procurement_contract_sent_index_path' do
        expect(response).to redirect_to facilities_management_rm3830_procurement_contract_sent_index_path(procurement.id, contract_id: next_contract.id)
      end

      it 'sets the next procurement state to sent' do
        next_contract.reload

        expect(next_contract.sent?).to be true
      end
    end

    context 'when contract is closed' do
      before do
        contract.update(aasm_state: 'accepted', supplier_response_date: Time.now.in_time_zone('London'))
        create(:facilities_management_rm3830_procurement_supplier_da_with_supplier, direct_award_value: 1234567, aasm_state: 'sent', procurement: procurement)
        put :update, params: { procurement_id: procurement.id, id: contract.id, name: 'signed', facilities_management_rm3830_procurement_supplier: { contract_signed: false, reason_for_not_signing: 'Some reason' } }
      end

      it 'redirects to the contract summary' do
        expect(response).to redirect_to facilities_management_rm3830_procurement_contract_path(procurement_id: procurement.id, id: contract.id)
      end
    end
  end

  describe '.authorize_user' do
    let(:contract) { create(:facilities_management_rm3830_procurement_supplier) }
    let(:procurement) { create(:facilities_management_rm3830_procurement, user: user) }
    let(:user) { create(:user, :with_detail, confirmed_at: Time.zone.now, roles: %i[buyer fm_access]) }
    let(:wrong_user) { create(:user, :with_detail, confirmed_at: Time.zone.now, roles: %i[buyer fm_access]) }

    context 'when the user is not the intended buyer' do
      before { sign_in wrong_user }

      it 'will not be able to manage the procurement' do
        ability = Ability.new(wrong_user)

        expect(ability.cannot?(:manage, procurement)).to be true
      end

      it 'redirects to the not permited page' do
        get :show, params: { procurement_id: procurement.id, id: contract.id }

        expect(response).to redirect_to '/facilities-management/RM3830/not-permitted'
      end
    end

    context 'when the user is the intended buyer' do
      before { sign_in user }

      it 'will be able to manage the procurement' do
        ability = Ability.new(user)

        expect(ability.can?(:manage, procurement)).to be true
      end

      it 'renders the show page' do
        get :show, params: { procurement_id: procurement.id, id: contract.id }

        expect(response).to render_template('show')
      end
    end
  end

  describe 'GET show' do
    let(:contract) { create(:facilities_management_rm3830_procurement_supplier) }
    let(:procurement) { create(:facilities_management_rm3830_procurement, user: controller.current_user) }

    context 'when logging in as an fm buyer' do
      login_fm_buyer_with_details

      it 'returns http success' do
        get :show, params: { procurement_id: procurement.id, id: contract.id }

        expect(response).to render_template(:show)
      end
    end

    context 'when logging in as a buyer without permissions' do
      login_buyer_without_permissions

      it 'redirects to the not permitted page' do
        get :show, params: { procurement_id: procurement.id, id: contract.id }

        expect(response).to redirect_to '/facilities-management/RM3830/not-permitted'
      end
    end

    context 'when logging in without buyer details' do
      login_fm_buyer

      it 'is expected to redirect to edit_facilities_management_buyer_detail_path' do
        get :show, params: { procurement_id: procurement.id, id: contract.id }

        expect(response).to redirect_to edit_facilities_management_buyer_detail_path(framework, controller.current_user.buyer_detail)
      end
    end
  end

  describe 'GET edit' do
    let(:procurement) { create(:facilities_management_rm3830_procurement, user: controller.current_user) }
    let(:contract) { create(:facilities_management_rm3830_procurement_supplier_da_with_supplier, procurement: procurement) }

    login_fm_buyer_with_details

    context 'when the name is not recognised' do
      it 'redirects to the show page' do
        get :edit, params: { procurement_id: procurement.id, id: contract.id, name: 'withold' }

        expect(response).to redirect_to facilities_management_rm3830_procurement_contract_path(procurement_id: procurement.id, id: contract.id)
      end
    end

    context 'when offering to next supplier' do
      let(:ineligible_contract) { create(:facilities_management_rm3830_procurement_supplier_da_with_supplier, procurement: procurement, direct_award_value: 2_000_000) }

      context 'with an eligible contract' do
        it 'returns the edit template' do
          get :edit, params: { procurement_id: procurement.id, id: contract.id, name: 'next_supplier' }

          expect(response).to render_template(:edit)
        end
      end

      context 'with an ineligible contract' do
        before { contract.update(aasm_state: 'declined') }

        it 'redirects to the sent contract page for the last sent contract' do
          get :edit, params: { procurement_id: procurement.id, id: ineligible_contract.id, name: 'next_supplier' }

          expect(response).to redirect_to facilities_management_rm3830_procurement_contract_sent_index_path(procurement.id, contract_id: contract.id)
        end
      end
    end

    context 'when going to next_supplier page' do
      let(:procurement_state) { 'direct_award' }

      before do
        create(:facilities_management_rm3830_procurement_supplier_da_with_supplier, procurement: procurement, direct_award_value: 1000000)
        procurement.update(aasm_state: procurement_state)
        contract.update(aasm_state: state)
        get :edit, params: { procurement_id: procurement.id, id: contract.id, name: 'next_supplier' }
      end

      context 'when the contract is sent' do
        let(:state) { 'sent' }

        it 'redirects to the contract summary' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_contract_path(procurement_id: procurement.id, id: contract.id)
        end
      end

      context 'when the contract is accepted' do
        let(:state) { 'accepted' }

        it 'redirects to the contract summary' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_contract_path(procurement_id: procurement.id, id: contract.id)
        end
      end

      context 'when the contract is signed' do
        let(:state) { 'signed' }

        it 'redirects to the contract summary' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_contract_path(procurement_id: procurement.id, id: contract.id)
        end
      end

      context 'when the contract is not_signed' do
        let(:state) { 'not_signed' }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end
      end

      context 'when the contract is declined' do
        let(:state) { 'declined' }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end
      end

      context 'when the contract is expired' do
        let(:state) { 'expired' }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end
      end

      context 'when the contract is withdrawn' do
        let(:state) { 'withdrawn' }
        let(:procurement_state) { 'closed' }

        it 'redirects to the contract summary' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_contract_path(procurement_id: procurement.id, id: contract.id)
        end
      end
    end

    context 'when withdrawing the contract' do
      let(:procurement_state) { 'direct_award' }

      before do
        procurement.update(aasm_state: procurement_state)
        contract.update(aasm_state: state)
        get :edit, params: { procurement_id: procurement.id, id: contract.id, name: 'withdraw' }
      end

      context 'when the contract is sent' do
        let(:state) { 'sent' }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end
      end

      context 'when the contract is accepted' do
        let(:state) { 'accepted' }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end
      end

      context 'when the contract is signed' do
        let(:state) { 'signed' }

        it 'redirects to the contract summary' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_contract_path(procurement_id: procurement.id, id: contract.id)
        end
      end

      context 'when the contract is not_signed' do
        let(:state) { 'not_signed' }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end
      end

      context 'when the contract is declined' do
        let(:state) { 'declined' }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end
      end

      context 'when the contract is expired' do
        let(:state) { 'expired' }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end
      end

      context 'when the contract is withdrawn' do
        let(:state) { 'withdrawn' }
        let(:procurement_state) { 'closed' }

        it 'redirects to the contract summary' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_contract_path(procurement_id: procurement.id, id: contract.id)
        end
      end
    end

    context 'when signing the contract' do
      before do
        contract.update(aasm_state: state)
        get :edit, params: { procurement_id: procurement.id, id: contract.id, name: 'signed' }
      end

      context 'when the contract is sent' do
        let(:state) { 'sent' }

        it 'redirects to the contract summary' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_contract_path(procurement_id: procurement.id, id: contract.id)
        end
      end

      context 'when the contract is accepted' do
        let(:state) { 'accepted' }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end
      end

      context 'when the contract is signed' do
        let(:state) { 'signed' }

        it 'redirects to the contract summary' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_contract_path(procurement_id: procurement.id, id: contract.id)
        end
      end

      context 'when the contract is not_signed' do
        let(:state) { 'not_signed' }

        it 'redirects to the contract summary' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_contract_path(procurement_id: procurement.id, id: contract.id)
        end
      end

      context 'when the contract is declined' do
        let(:state) { 'declined' }

        it 'redirects to the contract summary' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_contract_path(procurement_id: procurement.id, id: contract.id)
        end
      end

      context 'when the contract is expired' do
        let(:state) { 'expired' }

        it 'redirects to the contract summary' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_contract_path(procurement_id: procurement.id, id: contract.id)
        end
      end

      context 'when the contract is withdrawn' do
        let(:state) { 'withdrawn' }

        it 'redirects to the contract summary' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_contract_path(procurement_id: procurement.id, id: contract.id)
        end
      end
    end

    context 'when contract is closed' do
      before do
        contract.update(aasm_state: 'sent')
        create(:facilities_management_rm3830_procurement_supplier_da_with_supplier, direct_award_value: 1234567, aasm_state: 'sent', procurement: procurement)
        get :edit, params: { procurement_id: procurement.id, id: contract.id }
      end

      it 'redirects to the contract summary' do
        expect(response).to redirect_to facilities_management_rm3830_procurement_contract_path(procurement_id: procurement.id, id: contract.id)
      end
    end
  end
end
