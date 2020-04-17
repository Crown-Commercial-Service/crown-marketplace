require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementSupplier, type: :model do
  let(:current_year) { Date.current.year.to_s }
  let(:da_current_year_1) { create(:facilities_management_procurement_supplier_da, contract_number: "RM3860-DA0001-#{current_year}") }
  let(:da_current_year_2) { create(:facilities_management_procurement_supplier_da, contract_number: "RM3860-DA0002-#{current_year}") }
  let(:da_previous_year_1) { create(:facilities_management_procurement_supplier_da, contract_number: 'RM3860-DA0003-2019') }
  let(:da_previous_year_2) { create(:facilities_management_procurement_supplier_da, contract_number: 'RM3860-DA0004-2019') }
  let(:fc_current_year_1) { create(:facilities_management_procurement_supplier_fc, contract_number: "RM3860-FC0005-#{current_year}") }
  let(:fc_current_year_2) { create(:facilities_management_procurement_supplier_fc, contract_number: "RM3860-FC0006-#{current_year}") }
  let(:fc_previous_year_1) { create(:facilities_management_procurement_supplier_fc, contract_number: 'RM3860-FC0007-2019') }
  let(:fc_previous_year_2) { create(:facilities_management_procurement_supplier_fc, contract_number: 'RM3860-FC0008-2019') }

  before do
    da_current_year_1
    da_current_year_2
    da_previous_year_1
    da_previous_year_2
    fc_current_year_1
    fc_current_year_2
    fc_previous_year_1
    fc_previous_year_2
  end

  describe '.used_direct_award_contract_numbers_for_current_year' do
    it 'presents all of the direct award contract numbers used for the current year' do
      expect(described_class.used_direct_award_contract_numbers_for_current_year).to match(['0001', '0002'])
    end

    it 'does not present any of the direct award contract numbers used for the previous years' do
      expect(described_class.used_direct_award_contract_numbers_for_current_year).not_to match(['0003', '0004'])
    end
  end

  describe '.used_further_competition_contract_numbers_for_current_year' do
    it 'presents all of the further competition contract numbers used for the current year' do
      expect(described_class.used_further_competition_contract_numbers_for_current_year).to match(['0005', '0006'])
    end

    it 'does not present any of the further competition contract numbers used for the previous years' do
      expect(described_class.used_further_competition_contract_numbers_for_current_year).not_to match(['0007', '0008'])
    end
  end

  describe '.generate_contract_number' do
    let(:direct_award) { create(:facilities_management_procurement_supplier_da) }
    let(:further_competition) { create(:facilities_management_procurement_supplier_fc) }
    let(:number_array) { (1..9999).map { |integer| format('%04d', integer % 10000) } }
    let(:expected_number) { number_array.sample }

    before do
      allow(described_class).to receive(:used_direct_award_contract_numbers_for_current_year) { number_array - [expected_number] }
      allow(described_class).to receive(:used_further_competition_contract_numbers_for_current_year) { number_array - [expected_number] }
    end

    context 'with a procurement in direct award' do
      it 'returns an available number for a direct award contract' do
        expect(direct_award.send(:generate_contract_number)).to eq("RM3830-DA#{expected_number}-#{current_year}")
      end
    end
  end

  describe 'contracts' do
    let(:procurement) { create(:facilities_management_procurement, user: user) }
    let(:user) { create(:user) }
    let(:supplier_uuid) { 'eb7b05da-e52e-46a3-99ae-2cb0e6226232' }
    let(:da_value_test1) {  347.60116658878 }
    let(:da_value_test2) {  865.24783745402 }
    let(:da_value_test3) { 1292.48276446867 }
    let(:da_value_test4) { 1517.20280381278 }
    let(:obj) { double }

    before do
      allow(CCS::FM::Supplier.supplier_name('any')).to receive(:id).and_return(supplier_uuid)
      allow(FacilitiesManagement::EligibleSuppliers).to receive(:new).with(procurement.id).and_return(obj)
      allow(obj).to receive(:assessed_value).and_return(0.1234)
      allow(obj).to receive(:lot_number).and_return('1a')
      allow(obj).to receive(:sorted_list).and_return([[:test1, da_value_test1], [:test2, da_value_test2], [:test3, da_value_test3], [:test4, da_value_test4]])
      allow(procurement).to receive(:buildings_standard).and_return('STANDARD')
      procurement.save_eligible_suppliers_and_set_state
      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(described_class).to receive(:send_email_to_buyer).and_return(nil)
      allow_any_instance_of(described_class).to receive(:send_email_to_supplier).and_return(nil)
      # rubocop:enable RSpec/AnyInstance
      allow(FacilitiesManagement::ChangeStateWorker).to receive(:perform_at).and_return(nil)
      allow(FacilitiesManagement::ContractSentReminder).to receive(:perform_at).and_return(nil)
      allow(FacilitiesManagement::AwaitingSignatureReminder).to receive(:perform_at).and_return(nil)
    end

    describe '.real_date?' do
      let(:contract) { procurement.procurement_suppliers[0] }

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
      let(:contract) { procurement.procurement_suppliers[0] }

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

    # rubocop:disable RSpec/NestedGroups
    describe 'state changes' do
      let(:contract) { procurement.procurement_suppliers[0] }

      before { contract.offer_to_supplier }

      describe '.sent' do
        context 'when the offer gets sent' do
          it 'will call the ChangeStateWorker' do
            expect(FacilitiesManagement::ChangeStateWorker).to have_received(:perform_at)
          end

          it 'will call the ContractSentReminder' do
            expect(FacilitiesManagement::ContractSentReminder).to have_received(:perform_at)
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
            expect(FacilitiesManagement::AwaitingSignatureReminder).to have_received(:perform_at)
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
          let(:contract) { procurement.procurement_suppliers[0] }

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
        let(:contract) { procurement.procurement_suppliers[0] }

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

    describe '#contract_response' do
      let(:contract) { procurement.procurement_suppliers[0] }

      before { contract.offer_to_supplier }

      context 'when contract_response is nil' do
        it 'will not be valid' do
          expect(contract.contract_response).to be nil
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
            contract.contract_response = false
            expect(contract.contract_response).to be false
            expect(contract.valid?(:contract_response)).to be false
          end
        end

        context 'when contract_response is false and a reason is given' do
          it 'will be valid' do
            contract.reason_for_declining = 'This is test string'
            expect(contract.contract_response).to be false
            expect(contract.reason_for_declining).to match 'This is test string'
            expect(contract.valid?(:contract_response)).to be true
          end
        end

        context 'when contract_response is false and a reason is given that is more than 500 characters' do
          it 'will not be valid' do
            closed_reason = (0...501).map { ('a'..'z').to_a[rand(26)] }.join
            contract.reason_for_declining = closed_reason
            expect(contract.contract_response).to be false
            expect(contract.reason_for_declining).to match closed_reason
            expect(contract.valid?(:contract_response)).to be false
          end
        end
      end

      describe '#confirmation_of_signed_contract' do
        before do
          contract.accept!
        end

        context 'when nothing is selected' do
          it 'will not be valid' do
            expect(contract.valid?(:confirmation_of_signed_contract)).to be false
          end
        end

        context 'when the supplier has not signed' do
          context 'when no signing date is selected' do
            it 'will not be valid' do
              contract.contract_signed = false
              expect(contract.valid?(:confirmation_of_signed_contract)).to be false
            end

            it 'will not be valid with no reason for closing' do
              contract.contract_signed = false
              contract.reason_for_not_signing = nil
              expect(contract.valid?(:confirmation_of_signed_contract)).to be false
            end

            it 'will be valid with a reason for closing' do
              contract.contract_signed = false
              contract.reason_for_not_signing = 'reason'
              expect(contract.valid?(:confirmation_of_signed_contract)).to be true
            end

            it 'will be not valid with a reason for closing above 100 characters' do
              contract.contract_signed = false
              contract.reason_for_not_signing = (0...101).map { ('a'..'z').to_a[rand(26)] }.join
              expect(contract.valid?(:confirmation_of_signed_contract)).to be false
            end

            it 'will be valid with a reason for closing below 100 characters' do
              contract.contract_signed = false
              contract.reason_for_not_signing = 'In my younger and more vulnerable years my father gave me some advice'
              expect(contract.valid?(:confirmation_of_signed_contract)).to be true
            end
          end
        end

        context 'when the supplier has signed' do
          context 'when a contract start date has been added' do
            before do
              contract.contract_signed = true
            end

            context 'when a start date has been added without an end date' do
              it 'will not be valid' do
                contract.contract_start_date = DateTime.now.in_time_zone('London')
                expect(contract.valid?(:confirmation_of_signed_contract)).to be false
              end
            end

            context 'when the values entered are not numbers' do
              it 'will not be valid' do
                string = (0...rand(1..9)).map { ('a'..'z').to_a[rand(26)] }.join
                contract.contract_start_date_dd = string.split('').shuffle.join
                contract.contract_start_date_mm = string.split('').shuffle.join
                contract.contract_start_date_yyyy = string.split('').shuffle.join
                contract.contract_end_date_dd = string.split('').shuffle.join
                contract.contract_end_date_mm = string.split('').shuffle.join
                contract.contract_end_date_yyyy = string.split('').shuffle.join
                expect(contract.valid?(:confirmation_of_signed_contract)).to be false
              end
            end

            context 'when the values entered are numbers' do
              it 'will be valid' do
                contract.contract_start_date_dd = '1'
                contract.contract_start_date_mm = '11'
                contract.contract_start_date_yyyy = '2012'
                contract.contract_end_date_dd = '1'
                contract.contract_end_date_mm = '11'
                contract.contract_end_date_yyyy = '2025'
                expect(contract.valid?(:confirmation_of_signed_contract)).to be true
              end
            end

            context 'when the values entered are not real dates' do
              it 'will not be valid' do
                contract.contract_start_date_dd = '29'
                contract.contract_start_date_mm = '2'
                contract.contract_start_date_yyyy = '2019'
                contract.contract_end_date_dd = '15'
                contract.contract_end_date_mm = '2'
                contract.contract_end_date_yyyy = '2025'
                expect(contract.valid?(:confirmation_of_signed_contract)).to be false
              end
            end

            context 'when the values entered are not real dates' do
              it 'will not be valid' do
                contract.contract_start_date_dd = '01'
                contract.contract_start_date_mm = '01'
                contract.contract_start_date_yyyy = '2020'
                contract.contract_end_date_dd = '30'
                contract.contract_end_date_mm = '2'
                contract.contract_end_date_yyyy = '2020'
                expect(contract.valid?(:confirmation_of_signed_contract)).to be false
                expect(contract.errors.messages[:contract_end_date]).to include('Enter a valid end date')
              end
            end

            context 'when both a start and end date have been added' do
              it 'will be valid' do
                contract.contract_signed = true
                contract.contract_start_date = DateTime.now.in_time_zone('London')
                contract.contract_end_date = DateTime.now.in_time_zone('London') + 1.day
                expect(contract.valid?(:confirmation_of_signed_contract)).to be true
              end

              context 'when the end date is before the start date' do
                it 'will be valid' do
                  contract.contract_signed = true
                  contract.contract_start_date = DateTime.now.in_time_zone('London')
                  contract.contract_end_date = DateTime.now.in_time_zone('London') - 1.day
                  expect(contract.valid?(:confirmation_of_signed_contract)).to be false
                end
              end
            end
          end

          context 'when a contract end date has been added' do
            context 'when an end date has been added without a start date' do
              it 'will not be valid' do
                contract.contract_signed = true
                contract.contract_end_date = DateTime.now.in_time_zone('London') + 1
                expect(contract.valid?(:confirmation_of_signed_contract)).to be false
              end
            end

            context 'when both a start and end date have been added' do
              it 'will be valid' do
                contract.contract_signed = true
                contract.contract_start_date = DateTime.now.in_time_zone('London')
                contract.contract_end_date = DateTime.now.in_time_zone('London') + 1
                expect(contract.valid?(:confirmation_of_signed_contract)).to be true
              end
            end
          end
        end
      end
    end

    describe '#contract_expiry_date' do
      let(:contract) { procurement.procurement_suppliers[0] }

      before { contract.offer_to_supplier }

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

        context 'when a procurment is sent on a bank holiday' do
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
      let(:contract) { procurement.procurement_suppliers[0] }

      before { contract.offer_to_supplier }

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
    # rubocop:enable RSpec/NestedGroups
  end
end
