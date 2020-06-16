require 'rails_helper'

RSpec.describe FacilitiesManagement::Procurements::ContractsController, type: :controller do
  let(:procurement) { create(:facilities_management_procurement_with_contact_details, user: subject.current_user) }
  let(:contract) { create(:facilities_management_procurement_supplier_da_with_supplier, facilities_management_procurement_id: procurement.id, reason_for_closing: 'Close this', aasm_state: 'sent', offer_sent_date: Time.zone.now,) }
  let(:user) { subject.current_user }
  let(:wrong_user) { FactoryBot.create(:user, :without_detail, confirmed_at: Time.zone.now, roles: %i[buyer fm_access]) }
  let(:supplier) { create(:ccs_fm_supplier) }

  ENV['RAILS_ENV_URL'] = 'https://test-fm'

  describe 'PUT update' do
    login_fm_buyer_with_details

    context 'when the buyer closes the procurement' do
      let(:first_contract) { procurement.procurement_suppliers.min_by(&:direct_award_value) }

      before do
        first_contract.update(aasm_state: 'declined')
      end

      context 'when a reason for closing is given' do
        let(:reason_for_closing) { 'Taking too long' }

        before do
          put :update, params: { procurement_id: procurement.id, id: first_contract.id, close_procurement: 'Close procurement', facilities_management_procurement_supplier: { reason_for_closing: reason_for_closing } }
        end

        it 'redirects to facilities_management_procurement_contract_closed_index_path' do
          expect(response).to redirect_to facilities_management_procurement_contract_closed_index_path(procurement.id, contract_id: first_contract.id)
        end

        it 'updates the reason for closing' do
          first_contract.reload

          expect(first_contract.reason_for_closing).to eq reason_for_closing
        end
      end

      context 'when a reason for closing is not given' do
        it 'renders the edit page' do
          put :update, params: { procurement_id: procurement.id, id: first_contract.id, close_procurement: 'Close procurement', facilities_management_procurement_supplier: { reason_for_closing: '' } }

          expect(response).to render_template('edit')
        end
      end
    end

    context 'when the buyer signs the procurement' do
      let(:start_date) { Time.now.in_time_zone('London') + 2.years }
      let(:end_date) { Time.now.in_time_zone('London') + 4.years }

      before do
        contract.accept!
      end

      context 'when the buyer gives a valid date' do
        before do
          put :update, params: { procurement_id: procurement.id, id: contract.id, sign_procurement: 'Save and continue', facilities_management_procurement_supplier: { contract_signed: true, contract_start_date_dd: start_date.day.to_s, contract_start_date_mm: start_date.month.to_s, contract_start_date_yyyy: start_date.year.to_s, contract_end_date_dd: end_date.day.to_s, contract_end_date_mm: end_date.month.to_s, contract_end_date_yyyy: end_date.year.to_s } }
        end

        it 'redirects to facilities_management_procurement_contract_closed_index_path' do
          expect(response).to redirect_to facilities_management_procurement_contract_closed_index_path(procurement.id, contract_id: contract.id)
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
        it 'renders the edit page' do
          put :update, params: { procurement_id: procurement.id, id: contract.id, sign_procurement: 'Save and continue', facilities_management_procurement_supplier: { contract_signed: true, contract_start_date_dd: start_date.day.to_s, contract_start_date_mm: start_date.month.to_s, contract_start_date_yyyy: start_date.year.to_s, contract_end_date_dd: end_date.day.to_s, contract_end_date_yyyy: end_date.year.to_s } }

          expect(response).to render_template('edit')
        end
      end
    end

    context 'when the buyer does not sign the procurement' do
      before do
        contract.accept!
      end

      context 'when the buyer gives a valid reason' do
        let(:reason_for_not_signing) { 'The supplier did not respond' }

        before do
          put :update, params: { procurement_id: procurement.id, id: contract.id, sign_procurement: 'Save and continue', facilities_management_procurement_supplier: { contract_signed: false, reason_for_not_signing: reason_for_not_signing } }
        end

        it 'redirects to facilities_management_procurement_contract_closed_index_path' do
          expect(response).to redirect_to facilities_management_procurement_contract_path(procurement.id, contract_id: contract.id)
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
        it 'renders the edit page' do
          put :update, params: { procurement_id: procurement.id, id: contract.id, sign_procurement: 'Save and continue', facilities_management_procurement_supplier: { contract_signed: false } }

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
        put :update, params: { procurement_id: procurement.id, id: last_contract.id, send_contract_to_next_supplier: 'offer to next supplier' }
      end

      it 'redirects to facilities_management_procurement_contract_sent_index_path' do
        expect(response).to redirect_to facilities_management_procurement_contract_sent_index_path(procurement.id, contract_id: last_contract.id)
      end

      it 'sets the procurement state to closed' do
        procurement.reload

        expect(procurement.closed?).to be true
      end
    end

    context 'when offering to the next supplier' do
      let(:first_contract) { procurement.procurement_suppliers.min_by(&:direct_award_value) }
      let(:next_contract) { procurement.procurement_suppliers.sort_by(&:direct_award_value)[1] }

      before do
        first_contract.update(aasm_state: 'declined')
        next_contract.update(supplier_id: supplier.id)
        put :update, params: { procurement_id: procurement.id, id: first_contract.id, send_contract_to_next_supplier: 'offer to next supplier' }
      end

      it 'redirects to facilities_management_procurement_contract_sent_index_path' do
        expect(response).to redirect_to facilities_management_procurement_contract_sent_index_path(procurement.id, contract_id: next_contract.id)
      end

      it 'sets the next procurement state to sent' do
        next_contract.reload

        expect(next_contract.sent?).to be true
      end
    end
  end

  describe '.authorize_user' do
    let(:contract) { create(:facilities_management_procurement_supplier) }
    let(:procurement) { create(:facilities_management_procurement, user: user) }
    let(:user) { FactoryBot.create(:user, :with_detail, confirmed_at: Time.zone.now, roles: %i[buyer fm_access]) }
    let(:wrong_user) { FactoryBot.create(:user, :with_detail, confirmed_at: Time.zone.now, roles: %i[buyer fm_access]) }

    context 'when the user is not the intended buyer' do
      before { sign_in wrong_user }

      it 'will not be able to manage the procurement' do
        ability = Ability.new(wrong_user)
        assert ability.cannot?(:manage, procurement)
      end

      it 'redirects to the not permited page' do
        get :show, params: { procurement_id: procurement.id, id: contract.id }

        expect(response).to redirect_to not_permitted_url(service: 'facilities_management')
      end
    end

    context 'when the user is the intended buyer' do
      before { sign_in user }

      it 'will be able to manage the procurement' do
        ability = Ability.new(user)
        assert ability.can?(:manage, procurement)
      end

      it 'renders the show page' do
        get :show, params: { procurement_id: procurement.id, id: contract.id }

        expect(response).to render_template('show')
      end
    end
  end
end
