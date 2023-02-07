require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::ProcurementSupplier do
  describe 'contract number generation' do
    let(:current_year) { Date.current.year.to_s }

    describe '.generate_contract_number' do
      let(:direct_award) { create(:facilities_management_rm3830_procurement_supplier_da) }
      let(:number_array) { (1..9999).map { |integer| format('%04d', integer % 10000) } }
      let(:expected_number) { number_array.sample }

      # rubocop:disable RSpec/AnyInstance
      before { allow_any_instance_of(FacilitiesManagement::ContractNumberGenerator).to receive(:used_contract_numbers_for_current_year).and_return(number_array - [expected_number]) }
      # rubocop:enable RSpec/AnyInstance

      context 'with a procurement in direct award' do
        it 'returns an available number for a direct award contract' do
          expect(direct_award.send(:generate_contract_number)).to eq("RM3830-DA#{expected_number}-#{current_year}")
        end
      end
    end
  end

  # rubocop:disable RSpec/NestedGroups
  describe 'contracts' do
    let(:procurement) { create(:facilities_management_rm3830_procurement_detailed_search, user: user, aasm_state: 'direct_award') }
    let(:user) { create(:user) }
    let(:supplier_uuid) { 'eb7b05da-e52e-46a3-99ae-2cb0e6226232' }
    let(:da_value_test1) {  347.60116658878 }
    let(:da_value_test2) {  865.24783745402 }
    let(:da_value_test3) { 1292.48276446867 }
    let(:da_value_test4) { 1517.20280381278 }
    let(:supplier_ids) { FacilitiesManagement::RM3830::SupplierDetail.first(4).pluck(:supplier_id) }
    let(:obj) { double }
    let(:contract) { procurement.procurement_suppliers[0] }

    stub_bank_holiday_json

    before do
      [da_value_test1, da_value_test2, da_value_test3, da_value_test4].each_with_index do |da_value, index|
        procurement.procurement_suppliers.create(direct_award_value: da_value, supplier_id: supplier_ids[index])
      end
      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(described_class).to receive(:send_email_to_buyer).and_return(nil)
      allow_any_instance_of(described_class).to receive(:send_email_to_supplier).and_return(nil)
      # rubocop:enable RSpec/AnyInstance
      allow(FacilitiesManagement::RM3830::GenerateContractZip).to receive(:perform_in).and_return(nil)
      allow(FacilitiesManagement::RM3830::ChangeStateWorker).to receive(:perform_at).and_return(nil)
      allow(FacilitiesManagement::RM3830::ContractSentReminder).to receive(:perform_at).and_return(nil)
      allow(FacilitiesManagement::RM3830::AwaitingSignatureReminder).to receive(:perform_at).and_return(nil)
    end

    describe 'state changes' do
      before { contract.offer_to_supplier }

      describe '.sent' do
        context 'when the offer gets sent' do
          it 'will call the GenerateContractZip' do
            expect(FacilitiesManagement::RM3830::GenerateContractZip).to have_received(:perform_in)
          end

          it 'will call the ChangeStateWorker' do
            expect(FacilitiesManagement::RM3830::ChangeStateWorker).to have_received(:perform_at)
          end

          it 'will call the ContractSentReminder' do
            expect(FacilitiesManagement::RM3830::ContractSentReminder).to have_received(:perform_at)
          end
        end
      end

      describe '.accept' do
        context 'when the supplier accepts' do
          it 'will move the state to accepted' do
            expect(contract.aasm_state).to eq 'sent'
            expect(contract.accept!).to be true
            procurement.reload
            expect(contract.aasm_state).to eq 'accepted'
          end

          it 'will call the AwaitingSignatureReminder' do
            contract.accept!
            procurement.reload
            expect(FacilitiesManagement::RM3830::AwaitingSignatureReminder).to have_received(:perform_at)
          end
        end
      end

      describe '.decline' do
        context 'when the supplier declines' do
          it 'will move the state to declined' do
            expect(contract.aasm_state).to eq 'sent'
            expect(contract.decline!).to be true
            procurement.reload
            expect(contract.aasm_state).to eq 'declined'
          end
        end
      end
    end

    describe '.closed?' do
      context 'when all contracts are unsent' do
        it 'no contracts will be closed' do
          closed_contracts = procurement.procurement_suppliers.map(&:closed?)
          expect(closed_contracts.any?(true)).to be false
        end
      end

      context 'when three contracts are sent' do
        it 'will return true for the first 2 and false for the third' do
          procurement.procurement_suppliers[0].offer_to_supplier
          procurement.procurement_suppliers[1].offer_to_supplier
          closed_contracts = procurement.procurement_suppliers.map(&:closed?)
          expect(closed_contracts[0]).to be true
          expect(closed_contracts[1]).to be true
          expect(closed_contracts[2]).to be false
        end
      end

      describe '.declined' do
        context 'when a contract is declined by the supplier' do
          before do
            contract.offer_to_supplier!
            contract.decline!
          end

          context 'when the buyer closes the contract' do
            before do
              procurement.set_state_to_closed!
              procurement.reload
            end

            it 'will remain in a declined state on the procurement supplier' do
              expect(contract.aasm_state).to eq 'declined'
            end

            it 'will be closed' do
              expect(contract.closed?).to be true
            end
          end
        end
      end

      describe '.expires' do
        before do
          contract.offer_to_supplier!
          contract.expire!
        end

        context 'when the supplier doesnt respond to the offer' do
          it 'expect to move into expired state' do
            expect(contract.aasm_state).to eq 'expired'
          end

          it 'supplier reponse date to be the current date and time' do
            expect(contract.supplier_response_date.to_i).to be_within(2.seconds).of(DateTime.now.in_time_zone('London').to_i)
          end
        end
      end

      context 'when the procurement state is closed' do
        it 'will return true for all the contracts' do
          procurement.aasm_state = 'closed'
          closed_contracts = procurement.procurement_suppliers.map(&:closed?)
          expect(closed_contracts.any?(false)).to be false
        end

        it "will set the contract close date to today's date" do
          procurement.procurement_suppliers.last.offer_to_supplier!
          procurement.set_state_to_closed!
          procurement.procurement_suppliers.last.reload
          expect(procurement.procurement_suppliers.last.contract_closed_date.to_date).to eq Date.current
        end
      end
    end
  end

  describe 'contract methods' do
    let(:procurement) { create(:facilities_management_rm3830_procurement_detailed_search, user: user) }
    let(:user) { create(:user) }
    let(:contract) { procurement.procurement_suppliers.create(direct_award_value: 123456, supplier: FacilitiesManagement::RM3830::SupplierDetail.first) }

    stub_bank_holiday_json

    describe '.real_date?' do
      context 'when the date is not real' do
        it 'returns false' do
          contract.contract_start_date_dd = '29'
          contract.contract_start_date_mm = '2'
          contract.contract_start_date_yyyy = '2019'
          expect(contract.send(:real_date?, :contract_start_date)).to be false
        end
      end

      context 'when the date is real' do
        it 'returns true' do
          contract.contract_end_date_dd = '29'
          contract.contract_end_date_mm = '2'
          contract.contract_end_date_yyyy = '2020'
          expect(contract.send(:real_date?, :contract_end_date)).to be true
        end
      end
    end

    describe 'time_delta_in_day' do
      stub_bank_holiday_json

      context 'when sent on a Monday in a normal working week' do
        it 'is expected to return 1 day' do
          contract.offer_sent_date = DateTime.new(2020, 3, 9, 12, 0, 0).in_time_zone('London')
          expect(contract.send(:time_delta_in_days, contract.offer_sent_date, contract.contract_reminder_date)).to eq 1.day
        end
      end

      context 'when sent on a Friday in a normal working week' do
        it 'is expected to return 3 days' do
          contract.offer_sent_date = DateTime.new(2020, 3, 6, 12, 0, 0).in_time_zone('London')
          expect(contract.send(:time_delta_in_days, contract.offer_sent_date, contract.contract_reminder_date)).to eq 3.days
        end
      end

      context 'when sent on a Thursday with a bank holiday on Friday' do
        it 'is expected to return 4 days' do
          contract.offer_sent_date = DateTime.new(2020, 5, 7, 12, 0, 0).in_time_zone('London')
          expect(contract.send(:time_delta_in_days, contract.offer_sent_date, contract.contract_reminder_date)).to eq 4.days
        end
      end

      context 'when sent on the weekend at 12PM' do
        it 'is expected to return 1.5 days' do
          contract.offer_sent_date = DateTime.new(2020, 3, 8, 12, 0, 0).in_time_zone('London')
          expect(contract.send(:time_delta_in_days, contract.offer_sent_date, contract.contract_reminder_date)).to eq 1.5.days
        end
      end
    end

    describe '#contract_response' do
      before { contract.update(aasm_state: 'sent') }

      context 'when contract_response is nil' do
        it 'will not be valid' do
          expect(contract.contract_response).to be_nil
          expect(contract.valid?(:contract_response)).to be false
        end
      end

      context 'when contract_response is true' do
        it 'will be valid' do
          contract.contract_response = true
          expect(contract.contract_response).to be true
          expect(contract.valid?(:contract_response)).to be true
        end
      end

      describe '#reason_for_declining' do
        before { contract.contract_response = false }

        context 'when contract_response is false and no reason is given' do
          it 'will not be valid' do
            expect(contract.valid?(:contract_response)).to be false
          end

          it 'will have the correct error message' do
            contract.valid?(:contract_response)
            expect(contract.errors[:reason_for_declining].first).to eq 'Enter a reason for declining this contract offer'
          end
        end

        context 'when contract_response is false and a reason is given' do
          before { contract.reason_for_declining = 'This is test string' }

          it 'will be valid' do
            expect(contract.valid?(:contract_response)).to be true
          end
        end

        context 'when contract_response is false and a reason is given that is more than 500 characters' do
          before { contract.reason_for_declining = (0...501).map { ('a'..'z').to_a[rand(26)] }.join }

          it 'will not be valid' do
            expect(contract.valid?(:contract_response)).to be false
          end

          it 'will have the correct error message' do
            contract.valid?(:contract_response)
            expect(contract.errors[:reason_for_declining].first).to eq 'Reason for declining must be 500 characters or less'
          end
        end
      end
    end

    describe 'signing the contract' do
      before { contract.update(aasm_state: 'accepted') }

      context 'when nothing is selected' do
        it 'will not be valid' do
          expect(contract.valid?(:confirmation_of_signed_contract)).to be false
        end

        it 'will have the correct error message' do
          contract.valid?(:confirmation_of_signed_contract)
          expect(contract.errors[:contract_signed].first).to eq 'Select one option'
        end
      end

      context 'when the supplier has not signed' do
        before do
          contract.contract_signed = false
          contract.reason_for_not_signing = reason_for_not_signing
        end

        context 'when reason for closing is nil' do
          let(:reason_for_not_signing) { nil }

          it 'will not be valid' do
            expect(contract.valid?(:confirmation_of_signed_contract)).to be false
          end

          it 'will have the correct error message' do
            contract.valid?(:confirmation_of_signed_contract)
            expect(contract.errors[:reason_for_not_signing].first).to eq 'Enter a reason why this contract will not be signed'
          end
        end

        context 'when reason for closing is more than max characters' do
          let(:reason_for_not_signing) { (0...101).map { ('a'..'z').to_a[rand(26)] }.join }

          it 'will not be valid' do
            expect(contract.valid?(:confirmation_of_signed_contract)).to be false
          end

          it 'will have the correct error message' do
            contract.valid?(:confirmation_of_signed_contract)
            expect(contract.errors[:reason_for_not_signing].first).to eq 'Reason for not signing must be 100 characters or less'
          end
        end

        context 'when reason for closing is less than max characters' do
          let(:reason_for_not_signing) { 'In my younger and more vulnerable years my father gave me some advice' }

          it 'will be valid' do
            expect(contract.valid?(:confirmation_of_signed_contract)).to be true
          end
        end
      end

      context 'when the supplier has signed' do
        before do
          contract.contract_signed = true
        end

        context 'when entering individual date data' do
          before do
            contract.contract_start_date_dd = contract_start_date_dd
            contract.contract_start_date_mm = contract_start_date_mm
            contract.contract_start_date_yyyy = contract_start_date_yyyy
            contract.contract_end_date_dd = contract_end_date_dd
            contract.contract_end_date_mm = contract_end_date_mm
            contract.contract_end_date_yyyy = contract_end_date_yyyy
          end

          context 'when the values entered are not numbers' do
            let(:string) { (0...rand(1..9)).map { ('a'..'z').to_a[rand(26)] }.join }
            let(:contract_start_date_dd) { string.chars.shuffle.join }
            let(:contract_start_date_mm) { string.chars.shuffle.join }
            let(:contract_start_date_yyyy) { string.chars.shuffle.join }
            let(:contract_end_date_dd) { string.chars.shuffle.join }
            let(:contract_end_date_mm) { string.chars.shuffle.join }
            let(:contract_end_date_yyyy) { string.chars.shuffle.join }

            it 'will not be valid' do
              expect(contract.valid?(:confirmation_of_signed_contract)).to be false
            end

            it 'will have the correct error message' do
              contract.valid?(:confirmation_of_signed_contract)
              expect(contract.errors[:contract_start_date].first).to eq 'Enter a valid start date'
              expect(contract.errors[:contract_end_date].first).to eq 'Enter a valid end date'
            end
          end

          context 'when the values entered are numbers' do
            let(:contract_start_date_dd) { '1' }
            let(:contract_start_date_mm) { '11' }
            let(:contract_start_date_yyyy) { '2020' }
            let(:contract_end_date_dd) { '1' }
            let(:contract_end_date_mm) { '11' }
            let(:contract_end_date_yyyy) { '2025' }

            it 'will be valid' do
              expect(contract.valid?(:confirmation_of_signed_contract)).to be true
            end
          end

          context 'when the leap day is entered without a leap year' do
            let(:contract_start_date_dd) { '29' }
            let(:contract_start_date_mm) { '2' }
            let(:contract_start_date_yyyy) { '2019' }
            let(:contract_end_date_dd) { '15' }
            let(:contract_end_date_mm) { '2' }
            let(:contract_end_date_yyyy) { '2025' }

            it 'will not be valid' do
              expect(contract.valid?(:confirmation_of_signed_contract)).to be false
            end

            it 'will have the correct error message' do
              contract.valid?(:confirmation_of_signed_contract)
              expect(contract.errors[:contract_start_date].first).to eq 'Enter a valid start date'
              expect(contract.errors[:contract_end_date].first).to be_nil
            end
          end

          context 'when the values entered are not real dates' do
            let(:contract_start_date_dd) { '01' }
            let(:contract_start_date_mm) { '01' }
            let(:contract_start_date_yyyy) { '2021' }
            let(:contract_end_date_dd) { '30' }
            let(:contract_end_date_mm) { '2' }
            let(:contract_end_date_yyyy) { '2021' }

            it 'will not be valid' do
              expect(contract.valid?(:confirmation_of_signed_contract)).to be false
            end

            it 'will have the correct error message' do
              contract.valid?(:confirmation_of_signed_contract)
              expect(contract.errors[:contract_start_date].first).to be_nil
              expect(contract.errors[:contract_end_date].first).to eq 'Enter a valid end date'
            end
          end
        end

        context 'when entering the dates' do
          before do
            contract.contract_start_date = contract_start_date
            contract.contract_end_date = contract_end_date
          end

          context 'when a start date has been added without an end date' do
            let(:contract_start_date) { DateTime.now.in_time_zone('London') }
            let(:contract_end_date) { nil }

            it 'will not be valid' do
              expect(contract.valid?(:confirmation_of_signed_contract)).to be false
            end

            it 'will have the correct error message' do
              contract.valid?(:confirmation_of_signed_contract)
              expect(contract.errors[:contract_start_date].first).to be_nil
              expect(contract.errors[:contract_end_date].first).to eq 'Enter contract end date'
            end
          end

          context 'when an end date has been added without a start date' do
            let(:contract_start_date) { nil }
            let(:contract_end_date) { DateTime.now.in_time_zone('London') }

            it 'will not be valid' do
              expect(contract.valid?(:confirmation_of_signed_contract)).to be false
            end

            it 'will have the correct error message' do
              contract.valid?(:confirmation_of_signed_contract)
              expect(contract.errors[:contract_start_date].first).to eq 'Enter contract start date'
              expect(contract.errors[:contract_end_date].first).to be_nil
            end
          end

          context 'when the end date is before the start date' do
            let(:contract_start_date) { DateTime.now.in_time_zone('London') }
            let(:contract_end_date) { DateTime.now.in_time_zone('London') - 1.day }

            it 'will not be valid' do
              expect(contract.valid?(:confirmation_of_signed_contract)).to be false
            end

            it 'will have the correct error message' do
              contract.valid?(:confirmation_of_signed_contract)
              expect(contract.errors[:contract_start_date].first).to be_nil
              expect(contract.errors[:contract_end_date].first).to eq 'The contract end date must be after the contract start date'
            end
          end

          context 'when the start date is before June 2020' do
            let(:contract_start_date) { described_class::EARLIEST_CONTRACT_START_DATE - 1.day }
            let(:contract_end_date) { DateTime.now.in_time_zone('London') + 1.day }

            it 'will not be valid' do
              expect(contract.valid?(:confirmation_of_signed_contract)).to be false
            end

            it 'will have the correct error message' do
              contract.valid?(:confirmation_of_signed_contract)
              expect(contract.errors[:contract_start_date].first).to eq 'The contract start date must be on or after 1 June 2020'
              expect(contract.errors[:contract_end_date].first).to be_nil
            end
          end

          context 'when both a start and end date have been added' do
            let(:contract_start_date) { DateTime.now.in_time_zone('London') }
            let(:contract_end_date) { DateTime.now.in_time_zone('London') + 1.day }

            it 'will be valid' do
              expect(contract.valid?(:confirmation_of_signed_contract)).to be true
            end
          end
        end
      end
    end

    describe '#reason_for_closing' do
      before { contract.reason_for_closing = reason_for_closing }

      context 'when no reason is given' do
        let(:reason_for_closing) { nil }

        it 'will not be valid' do
          expect(contract.valid?(:reason_for_closing)).to be false
        end

        it 'will have the correct error message' do
          contract.valid?(:reason_for_closing)
          expect(contract.errors[:reason_for_closing].first).to eq 'Enter a reason for closing this procurement'
        end
      end

      context 'when a reason is given' do
        let(:reason_for_closing) { 'This is test string' }

        it 'will be valid' do
          expect(contract.valid?(:reason_for_closing)).to be true
        end
      end

      context 'when a reason is given that is more than 500 characters' do
        let(:reason_for_closing) { (0...501).map { ('a'..'z').to_a[rand(26)] }.join }

        it 'will not be valid' do
          expect(contract.valid?(:reason_for_closing)).to be false
        end

        it 'will have the correct error message' do
          contract.valid?(:reason_for_closing)
          expect(contract.errors[:reason_for_closing].first).to eq 'Reason for closing must be 500 characters or less'
        end
      end
    end

    describe '#contract_expiry_date' do
      before { contract.update(aasm_state: 'sent') }

      stub_bank_holiday_json

      # NO BANK HOLIDAYS
      context 'when it is a normal week without bank holidays' do
        context 'when a procurement is sent on Monday' do
          it 'is expected to expire on Wednesday' do
            contract.offer_sent_date = DateTime.new(2020, 3, 2, 12, 12, 12).in_time_zone('London')
            expect(contract.contract_expiry_date).to eq DateTime.new(2020, 3, 4, 12, 12, 12).in_time_zone('London')
          end
        end

        context 'when a procurement is sent on Tuesday' do
          it 'is expected to expire on Thursday' do
            contract.offer_sent_date = DateTime.new(2020, 6, 2, 13, 4, 7).in_time_zone('London')
            expect(contract.contract_expiry_date).to eq DateTime.new(2020, 6, 4, 13, 4, 7).in_time_zone('London')
          end
        end

        context 'when a procurement is sent on Wednesday' do
          it 'is expected to expire on Friday' do
            contract.offer_sent_date = DateTime.new(2020, 7, 8, 0, 8, 9).in_time_zone('London')
            expect(contract.contract_expiry_date).to eq DateTime.new(2020, 7, 10, 0, 8, 9).in_time_zone('London')
          end
        end

        context 'when a procurement is sent on Thrusday' do
          it 'is expected to expire on Monday' do
            contract.offer_sent_date = DateTime.new(2020, 6, 4, 1, 2, 3).in_time_zone('London')
            expect(contract.contract_expiry_date).to eq DateTime.new(2020, 6, 8, 1, 2, 3).in_time_zone('London')
          end
        end

        context 'when a procurement is sent on Friday' do
          it 'is expected to expire on Tuesday' do
            contract.offer_sent_date = DateTime.new(2020, 3, 6, 4, 5, 6).in_time_zone('London')
            expect(contract.contract_expiry_date).to eq DateTime.new(2020, 3, 10, 4, 5, 6).in_time_zone('London')
          end
        end

        context 'when a procurement is sent on Saturday' do
          it 'is expected to expire on Wednesday' do
            contract.offer_sent_date = DateTime.new(2020, 6, 6, 7, 8, 9).in_time_zone('London')
            expect(contract.contract_expiry_date).to eq DateTime.new(2020, 6, 9, 23, 0, 0).in_time_zone('London')
          end
        end

        context 'when a procurement is sent on Sunday' do
          it 'is expected to expire on Wednesday' do
            contract.offer_sent_date = DateTime.new(2020, 3, 8, 12, 12, 12).in_time_zone('London')
            expect(contract.contract_expiry_date).to eq DateTime.new(2020, 3, 11, 0, 0, 0).in_time_zone('London')
          end
        end
      end

      # BANK HOLIDAYS
      context 'when it is a week with bank holidays' do
        context 'when a procurement is sent on Monday with a bank holiday on Tuesday' do
          it 'is expected to expire on the next Thursday' do
            contract.offer_sent_date = DateTime.new(2018, 12, 31, 7, 8, 9).in_time_zone('London')
            expect(contract.contract_expiry_date).to eq DateTime.new(2019, 1, 4, 7, 8, 9).in_time_zone('London')
          end
        end

        context 'when a procurement is sent on Tuesday with a bank holiday on Wednesday and Thursday' do
          it 'is expected to expire on the next Monday' do
            contract.offer_sent_date = DateTime.new(2019, 12, 31, 10, 11, 12).in_time_zone('London')
            expect(contract.contract_expiry_date).to eq DateTime.new(2020, 1, 6, 10, 11, 12).in_time_zone('London')
          end
        end

        context 'when a procurement is sent on Wednesday with a bank holiday on Friday' do
          it 'is expected to expire on the next Monday' do
            contract.offer_sent_date = DateTime.new(2020, 5, 6, 16, 40, 49).in_time_zone('London')
            expect(contract.contract_expiry_date).to eq DateTime.new(2020, 5, 11, 16, 40, 49).in_time_zone('London')
          end
        end

        context 'when a procurement is sent on Thrusday with a bank holiday on Monday' do
          it 'is expected to expire on the next Tuesday' do
            contract.offer_sent_date = DateTime.new(2018, 5, 3, 13, 5, 19).in_time_zone('London')
            expect(contract.contract_expiry_date).to eq DateTime.new(2018, 5, 8, 13, 5, 19).in_time_zone('London')
          end
        end

        context 'when a procurement is sent on Friday with a bank holiday on Monday' do
          it 'is expected to expire on the next Wednesday' do
            contract.offer_sent_date = DateTime.new(2019, 8, 2, 18, 4, 7).in_time_zone('London')
            expect(contract.contract_expiry_date).to eq DateTime.new(2019, 8, 7, 18, 4, 7).in_time_zone('London')
          end
        end

        context 'when a procurement is sent on Saturday with a bank holiday on Monday' do
          it 'is expected to expire on the next Thursday' do
            contract.offer_sent_date = DateTime.new(2020, 8, 29, 4, 48, 52).in_time_zone('London')
            expect(contract.contract_expiry_date).to eq DateTime.new(2020, 9, 2, 23, 0, 0).in_time_zone('London')
          end
        end

        context 'when a procurement is sent on a bank holiday' do
          it 'is expected to expire in two working days' do
            contract.offer_sent_date = DateTime.new(2019, 5, 6, 4, 37, 12).in_time_zone('London')
            expect(contract.contract_expiry_date).to eq DateTime.new(2019, 5, 8, 23, 0, 0).in_time_zone('London')
            contract.offer_sent_date = DateTime.new(2021, 8, 29, 23, 4, 3).in_time_zone('London')
            expect(contract.contract_expiry_date).to eq DateTime.new(2021, 9, 1, 23, 0, 0).in_time_zone('London')
            contract.offer_sent_date = DateTime.new(2020, 12, 25, 10, 10, 10).in_time_zone('London')
            expect(contract.contract_expiry_date).to eq DateTime.new(2020, 12, 31, 0, 0, 0).in_time_zone('London')
          end
        end
      end

      context 'when changeing from BST' do
        context 'when sent on Thursday' do
          it 'is expected to expire on the next Monday at the same time of day' do
            contract.offer_sent_date = DateTime.new(2019, 10, 24, 5, 0, 0).in_time_zone('London')
            expect(contract.contract_expiry_date).to eq DateTime.new(2019, 10, 28, 5, 0, 0).in_time_zone('London')
          end
        end

        context 'when sent at 2am on the Sunday' do
          it 'is expected to expire on the next Wednesday at midnight' do
            contract.offer_sent_date = DateTime.new(2019, 10, 27, 2, 0, 0).in_time_zone('London')
            expect(contract.contract_expiry_date).to eq DateTime.new(2019, 10, 30, 0, 0, 0).in_time_zone('London')
          end
        end
      end

      context 'when changing to BST' do
        context 'when sent on Friday' do
          it 'is expected to expire on the next Tuesday at the same time of day' do
            contract.offer_sent_date = DateTime.new(2020, 3, 27, 0, 39, 8).in_time_zone('London')
            expect(contract.contract_expiry_date).to eq DateTime.new(2020, 3, 31, 0, 39, 8).in_time_zone('London')
          end
        end

        context 'when sent at 2am on the Sunday' do
          it 'is expected to expire on the next Wednesday at midnight' do
            contract.offer_sent_date = DateTime.new(2020, 3, 28, 2, 0, 0).in_time_zone('London')
            expect(contract.contract_expiry_date).to eq DateTime.new(2020, 3, 31, 23, 0, 0).in_time_zone('London')
          end
        end
      end
    end

    describe '#contract_reminder_date' do
      before { contract.update(aasm_state: 'sent') }

      stub_bank_holiday_json

      context 'when contract is sent in a normal week without bank holidays' do
        it 'is expected to have reminder date in one working day' do
          contract.offer_sent_date = DateTime.new(2020, 3, 2, 3, 45, 12).in_time_zone('London')
          expect(contract.contract_reminder_date).to eq DateTime.new(2020, 3, 3, 3, 45, 12).in_time_zone('London')
          contract.offer_sent_date = DateTime.new(2020, 6, 4, 6, 7, 43).in_time_zone('London')
          expect(contract.contract_reminder_date).to eq DateTime.new(2020, 6, 5, 6, 7, 43).in_time_zone('London')
          contract.offer_sent_date = DateTime.new(2020, 3, 8, 16, 13, 22).in_time_zone('London')
          expect(contract.contract_reminder_date).to eq DateTime.new(2020, 3, 10, 0, 0, 0).in_time_zone('London')
        end
      end

      context 'when contract is sent in a week with bank holidays' do
        it 'is expected to have reminder date in one working day' do
          contract.offer_sent_date = DateTime.new(2018, 12, 31, 14, 11, 59).in_time_zone('London')
          expect(contract.contract_reminder_date).to eq DateTime.new(2019, 1, 3, 14, 11, 59).in_time_zone('London')
          contract.offer_sent_date = DateTime.new(2018, 5, 3, 4, 3, 7).in_time_zone('London')
          expect(contract.contract_reminder_date).to eq DateTime.new(2018, 5, 4, 4, 3, 7).in_time_zone('London')
          contract.offer_sent_date = DateTime.new(2020, 8, 29, 3, 4, 5).in_time_zone('London')
          expect(contract.contract_reminder_date).to eq DateTime.new(2020, 9, 1, 23, 0, 0).in_time_zone('London')
        end

        context 'when the contract is sent on a bank holiday' do
          it 'is expected to have reminder date in one working day' do
            contract.offer_sent_date = DateTime.new(2019, 5, 6, 5, 12, 13).in_time_zone('London')
            expect(contract.contract_reminder_date).to eq DateTime.new(2019, 5, 7, 23, 0, 0).in_time_zone('London')
            contract.offer_sent_date = DateTime.new(2018, 8, 6, 12, 3, 6).in_time_zone('London')
            expect(contract.contract_reminder_date).to eq DateTime.new(2018, 8, 7, 23, 0, 0).in_time_zone('London')
            contract.offer_sent_date = DateTime.new(2020, 12, 25, 4, 3, 0).in_time_zone('London')
            expect(contract.contract_reminder_date).to eq DateTime.new(2020, 12, 30, 0, 0, 0).in_time_zone('London')
          end
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups

  describe '.closed_date' do
    let(:procurement) { create(:facilities_management_rm3830_procurement_detailed_search, user: user) }
    let(:user) { create(:user) }
    let(:contract_signed_date) { Time.now.in_time_zone('London') }
    let(:supplier_response_date) { Time.now.in_time_zone('London') - 1.week }
    let(:contract_closed_date) { Time.now.in_time_zone('London') - 2.weeks }
    let(:contract) { procurement.procurement_suppliers.create(direct_award_value: 123456, supplier_id: 'eb7b05da-e52e-46a3-99ae-2cb0e6226232', aasm_state: state, contract_signed_date: contract_signed_date, supplier_response_date: supplier_response_date, contract_closed_date: contract_closed_date) }

    context 'when the contract is not_signed' do
      let(:state) { 'not_signed' }

      it 'means the closed date is contract_signed_date' do
        expect(contract.closed_date).to eq contract_signed_date
      end
    end

    context 'when the contract is withdrawn' do
      let(:state) { 'withdrawn' }

      it 'means the closed date is contract_closed_date' do
        expect(contract.closed_date).to eq contract_closed_date
      end
    end

    context 'when the contract is declined' do
      let(:state) { 'declined' }

      it 'means the closed date is supplier_response_date' do
        expect(contract.closed_date).to eq supplier_response_date
      end
    end

    context 'when the contract is expired' do
      let(:state) { 'expired' }

      it 'means the closed date is supplier_response_date' do
        expect(contract.closed_date).to eq supplier_response_date
      end
    end
  end

  describe '.cannot_offer_to_next_supplier?' do
    let(:contract) { procurement.procurement_suppliers.create(direct_award_value: 123456, supplier_id: 'eb7b05da-e52e-46a3-99ae-2cb0e6226232', aasm_state: state) }
    let(:procurement) { create(:facilities_management_rm3830_procurement_detailed_search, user: user, aasm_state: procurement_state) }
    let(:user) { create(:user) }
    let(:procurement_state) { 'direct_award' }

    context 'when the contract is sent' do
      let(:state) { 'sent' }

      it 'cannot_offer_to_next_supplier returns true' do
        expect(contract.cannot_offer_to_next_supplier?).to be true
      end
    end

    context 'when the contract is accepted' do
      let(:state) { 'accepted' }

      it 'cannot_offer_to_next_supplier returns true' do
        expect(contract.cannot_offer_to_next_supplier?).to be true
      end
    end

    context 'when the contract is signed' do
      let(:state) { 'signed' }

      it 'cannot_offer_to_next_supplier returns true' do
        expect(contract.cannot_offer_to_next_supplier?).to be true
      end
    end

    context 'when the contract is not_signed' do
      let(:state) { 'not_signed' }

      it 'cannot_offer_to_next_supplier returns false' do
        expect(contract.cannot_offer_to_next_supplier?).to be false
      end
    end

    context 'when the contract is declined' do
      let(:state) { 'declined' }

      it 'cannot_offer_to_next_supplier returns false' do
        expect(contract.cannot_offer_to_next_supplier?).to be false
      end
    end

    context 'when the contract is expired' do
      let(:state) { 'expired' }

      it 'cannot_offer_to_next_supplier returns false' do
        expect(contract.cannot_offer_to_next_supplier?).to be false
      end
    end

    context 'when the contract is withdrawn' do
      let(:state) { 'withdrawn' }
      let(:procurement_state) { 'closed' }

      it 'cannot_offer_to_next_supplier returns true' do
        expect(contract.cannot_offer_to_next_supplier?).to be true
      end
    end
  end

  describe '.cannot_withdraw?' do
    let(:contract) { procurement.procurement_suppliers.create(direct_award_value: 123456, supplier_id: 'eb7b05da-e52e-46a3-99ae-2cb0e6226232', aasm_state: state) }
    let(:procurement) { create(:facilities_management_rm3830_procurement_detailed_search, user: user, aasm_state: procurement_state) }
    let(:user) { create(:user) }
    let(:procurement_state) { 'direct_award' }

    context 'when the contract is sent' do
      let(:state) { 'sent' }

      it 'cannot_withdraw returns true' do
        expect(contract.cannot_withdraw?).to be false
      end
    end

    context 'when the contract is accepted' do
      let(:state) { 'accepted' }

      it 'cannot_withdraw returns true' do
        expect(contract.cannot_withdraw?).to be false
      end
    end

    context 'when the contract is signed' do
      let(:state) { 'signed' }

      it 'cannot_withdraw returns true' do
        expect(contract.cannot_withdraw?).to be true
      end
    end

    context 'when the contract is not_signed' do
      let(:state) { 'not_signed' }

      it 'cannot_withdraw returns false' do
        expect(contract.cannot_withdraw?).to be false
      end
    end

    context 'when the contract is declined' do
      let(:state) { 'declined' }

      it 'cannot_withdraw returns false' do
        expect(contract.cannot_withdraw?).to be false
      end
    end

    context 'when the contract is expired' do
      let(:state) { 'expired' }

      it 'cannot_withdraw returns false' do
        expect(contract.cannot_withdraw?).to be false
      end
    end

    context 'when the contract is withdrawn' do
      let(:state) { 'withdrawn' }
      let(:procurement_state) { 'closed' }

      it 'cannot_withdraw returns true' do
        expect(contract.cannot_withdraw?).to be true
      end
    end
  end
end
