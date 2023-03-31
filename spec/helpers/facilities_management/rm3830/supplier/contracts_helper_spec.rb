require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Supplier::ContractsHelper do
  extend APIRequestStubs

  describe '.supplier_contract_reason_id' do
    subject(:result) { helper.supplier_contract_reason_id(state) }

    context 'when the state is sent' do
      let(:state) { 'sent' }

      it 'returns no-reason-required' do
        expect(result).to eq 'no-reason-required'
      end
    end

    context 'when the state is accepted' do
      let(:state) { 'accepted' }

      it 'returns no-reason-required' do
        expect(result).to eq 'no-reason-required'
      end
    end

    context 'when the state is signed' do
      let(:state) { 'signed' }

      it 'returns no-reason-required' do
        expect(result).to eq 'no-reason-required'
      end
    end

    context 'when the state is not_signed' do
      let(:state) { 'not_signed' }

      it 'returns reason-for-not-signing' do
        expect(result).to eq 'reason-for-not-signing'
      end
    end

    context 'when the state is declined' do
      let(:state) { 'declined' }

      it 'returns reason-for-declining' do
        expect(result).to eq 'reason-for-declining'
      end
    end

    context 'when the state is withdrawn' do
      let(:state) { 'withdrawn' }

      it 'returns reason-for-closing' do
        expect(result).to eq 'reason-for-closing'
      end
    end

    context 'when the state is expired' do
      let(:state) { 'expired' }

      it 'returns no-reason-required' do
        expect(result).to eq 'no-reason-required'
      end
    end
  end

  def format_date_time(date_object)
    date_object.strftime '%e %B %Y, %l:%M%P'
  end

  describe '.warning_message and WARNINGS' do
    let(:contract) { create(:facilities_management_rm3830_procurement_supplier, aasm_state: aasm_state, offer_sent_date: Time.new(2021, 7, 5, 20, 0, 0).in_time_zone('London'), **attributes) }
    let(:attributes) { {} }
    let(:warning_title) { helper.warning_title }
    let(:warning_message) { helper.warning_message }

    stub_bank_holiday_json

    before { @contract = contract }

    context 'when the state is sent' do
      let(:aasm_state) { :sent }

      it 'has the correct warning' do
        expect(warning_title).to eq 'Received contract offer'
      end

      it 'has the correct warning message' do
        expect(warning_message).to eq "This contract offer expires on #{format_date_time(Time.new(2021, 7, 7, 20, 0, 0).in_time_zone('London'))}.<br/> The buyer is waiting for a response before the offer expiry deadline shown above."
      end
    end

    context 'when the state is accepted' do
      let(:aasm_state) { :accepted }

      it 'has the correct warning' do
        expect(warning_title).to eq 'Accepted'
      end

      it 'has the correct warning message' do
        expect(warning_message).to eq 'Awaiting buyer confirmation of signed contract.'
      end
    end

    context 'when the state is signed' do
      let(:aasm_state) { :signed }
      let(:attributes) { { contract_start_date: Time.new(2021, 7, 7).in_time_zone('London'), contract_end_date: Time.new(2022, 12, 18).in_time_zone('London') } }

      it 'has the correct warning' do
        expect(warning_title).to eq 'Accepted and signed'
      end

      it 'has the correct warning message' do
        expect(warning_message).to eq 'The buyer confirmed that the contract period is between  7 July 2021 and 18 December 2022.'
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
        expect(warning_message).to eq "You declined this contract offer on #{format_date_time(supplier_response_date)}."
      end
    end

    context 'when the state is expired' do
      let(:aasm_state) { :expired }

      it 'has the correct warning' do
        expect(warning_title).to eq 'Not responded'
      end

      it 'has the correct warning message' do
        expect(warning_message).to eq "You did not respond to this contract offer within the required timescales,<br/> therefore it was automatically declined with the reason of 'no response'."
      end
    end

    context 'when the state is not_signed' do
      let(:aasm_state) { :not_signed }
      let(:attributes) { { contract_signed_date: } }
      let(:contract_signed_date) { Time.new(2021, 7, 7, 20, 39, 0).in_time_zone('London') }

      it 'has the correct warning' do
        expect(warning_title).to eq 'Not signed'
      end

      it 'has the correct warning message' do
        expect(warning_message).to eq "The buyer has recorded this contract as 'not signed' on #{format_date_time(contract_signed_date)}.<br> The contract offer has therefore been closed."
      end
    end

    context 'when the state is withdrawn' do
      let(:aasm_state) { :withdrawn }
      let(:attributes) { { contract_closed_date: } }
      let(:contract_closed_date) { Time.new(2021, 7, 7, 22, 13, 0).in_time_zone('London') }

      it 'has the correct warning' do
        expect(warning_title).to eq 'Withdrawn'
      end

      it 'has the correct warning message' do
        expect(warning_message).to eq "The buyer withdrew this contract offer and closed this procurement on <br/> #{format_date_time(contract_closed_date)}."
      end
    end
  end
end
