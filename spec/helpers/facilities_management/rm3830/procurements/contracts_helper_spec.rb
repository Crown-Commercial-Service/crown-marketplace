require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Procurements::ContractsHelper do
  extend APIRequestStubs

  def format_date_time(date_object)
    date_object.strftime '%e %B %Y, %l:%M%P'
  end

  describe '.warning_message and warning_title' do
    let(:contract) { create(:facilities_management_rm3830_procurement_supplier, aasm_state: aasm_state, offer_sent_date: Time.new(2021, 7, 5, 20, 0, 0).in_time_zone('London'), procurement: procurement, **attributes) }
    let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings, aasm_state: procurement_state) }
    let(:procurement_state) { :direct_award }
    let(:attributes) { {} }
    let(:warning_title) { helper.warning_title }
    let(:warning_message) { helper.warning_message }

    stub_bank_holiday_json

    before { @contract = contract }

    context 'when the state is sent' do
      let(:aasm_state) { :sent }

      it 'has the correct warning' do
        expect(warning_title).to eq 'Sent'
      end

      it 'has the correct warning message' do
        expect(warning_message).to eq "This contract offer expires on #{format_date_time(Time.new(2021, 7, 7, 20, 0, 0).in_time_zone('London'))}.<br/> The supplier has not yet responded."
      end
    end

    context 'when the state is accepted' do
      let(:aasm_state) { :accepted }

      it 'has the correct warning' do
        expect(warning_title).to eq 'Accepted, awaiting contract signature'
      end

      it 'has the correct warning message' do
        expect(warning_message).to eq 'Awaiting your confirmation of signed contract.'
      end
    end

    context 'when the state is signed' do
      let(:aasm_state) { :signed }
      let(:attributes) { { contract_start_date: Time.new(2021, 7, 7).in_time_zone('London'), contract_end_date: Time.new(2022, 12, 18).in_time_zone('London') } }

      it 'has the correct warning' do
        expect(warning_title).to eq 'Accepted and signed'
      end

      it 'has the correct warning message' do
        expect(warning_message).to eq 'You confirmed that the contract period is between  7 July 2021 and 18 December 2022.'
      end
    end

    context 'when the state is declined' do
      let(:aasm_state) { :declined }
      let(:attributes) { { supplier_response_date: } }
      let(:supplier_response_date) { Time.new(2021, 7, 7, 20, 29, 0).in_time_zone('London') }

      it 'has the correct warning' do
        expect(warning_title).to eq 'Declined'
      end

      it 'has the correct warning message' do
        expect(warning_message).to eq "The supplier declined this offer on #{format_date_time(supplier_response_date)}."
      end
    end

    context 'when the state is expired' do
      let(:aasm_state) { :expired }

      it 'has the correct warning' do
        expect(warning_title).to eq 'Not responded'
      end

      it 'has the correct warning message' do
        expect(warning_message).to eq 'The supplier did not respond to your contract offer within the required 2 working days (48 hours).'
      end
    end

    context 'when the state is not_signed' do
      let(:aasm_state) { :not_signed }
      let(:attributes) { { contract_signed_date: } }
      let(:contract_signed_date) { Time.new(2021, 7, 7, 20, 39, 0).in_time_zone('London') }

      it 'has the correct warning' do
        expect(warning_title).to eq 'Accepted, not signed'
      end

      it 'has the correct warning message' do
        expect(warning_message).to eq "You confirmed on the #{format_date_time(contract_signed_date)} that the contract has not been signed."
      end
    end

    context 'when the state is withdrawn' do
      let(:aasm_state) { :withdrawn }
      let(:procurement_state) { :closed }
      let(:attributes) { { contract_closed_date: contract_closed_date, reason_for_closing: 'Some reason' } }
      let(:contract_closed_date) { Time.new(2021, 7, 7, 22, 13, 0).in_time_zone('London') }

      it 'has the correct warning' do
        expect(warning_title).to eq 'Closed'
      end

      it 'has the correct warning message' do
        expect(warning_message).to eq "You closed this contract offer on #{format_date_time(contract_closed_date)}."
      end
    end

    context 'when the contract is closed' do
      let(:aasm_state) { :declined }
      let(:attributes) { { contract_closed_date: } }
      let(:contract_closed_date) { Time.new(2021, 7, 7, 22, 35, 0).in_time_zone('London') }

      context 'with it being the last offer' do
        let(:procurement_state) { :closed }

        it 'has the correct warning' do
          expect(warning_title).to eq 'Closed'
        end

        it 'has the correct warning message' do
          expect(warning_message).to eq "The contract offer was automatically closed on #{format_date_time(contract_closed_date)} when you tried to offer the procurement to the next supplier, but there were no more suppliers."
        end
      end

      context 'with it being sent to another supplier' do
        before { create(:facilities_management_rm3830_procurement_supplier, direct_award_value: 110000, aasm_state: 'sent', procurement: procurement) }

        it 'has the correct warning' do
          expect(warning_title).to eq 'Closed'
        end

        it 'has the correct warning message' do
          expect(warning_message).to eq "The contract offer was automatically closed when you offered the procurement to the next supplier on #{format_date_time(contract_closed_date)}."
        end
      end
    end
  end
end
