require 'rails_helper'

RSpec.describe FacilitiesManagement::ContractNumberGenerator do
  describe '.new_number' do
    let(:contract_number_generator) { described_class.new(procurement_state: procurement_state, framework: 'RM1234', model: nil) }

    before { allow(contract_number_generator).to receive(:used_contract_numbers_for_current_year).and_return([]) }

    context 'with a procurement in direct_award' do
      let(:procurement_state) { :direct_award }

      it 'has the correct format' do
        expect(contract_number_generator.new_number).to match(/\ARM1234-DA\d{4}-\d{4}\z/)
      end

      it 'has the current year as the final 4 digits' do
        current_year = Date.current.year.to_s

        expect(contract_number_generator.new_number.split('-')[2]).to eq(current_year)
      end
    end

    context 'with a procurement going to further_competition' do
      let(:procurement_state) { :further_competition }

      it 'has the correct format' do
        expect(contract_number_generator.new_number).to match(/\ARM1234-FC\d{4}-\d{4}\z/)
      end

      it 'has the current year as the final 4 digits' do
        current_year = Date.current.year.to_s

        expect(contract_number_generator.new_number.split('-')[2]).to eq(current_year)
      end
    end

    context 'with a procurement state is nil' do
      let(:procurement_state) { nil }

      it 'has the correct format' do
        expect(contract_number_generator.new_number).to match(/\ARM1234-\d{6}-\d{4}\z/)
      end

      it 'has the current year as the final 4 digits' do
        current_year = Date.current.year.to_s

        expect(contract_number_generator.new_number.split('-')[2]).to eq(current_year)
      end
    end
  end

  describe '.used_contract_numbers_for_current_year' do
    context 'when the framework is RM3830' do
      let(:contract_number_generator) { described_class.new(procurement_state: procurement_state, framework: 'RM3830', model: model) }
      let(:current_year) { Date.current.year.to_s }

      context 'when the procurement is not direct award eligable' do
        let(:procurement_state) { :further_competition }
        let(:model) { FacilitiesManagement::RM3830::Procurement }

        before do
          create(:facilities_management_rm3830_procurement_further_competition, contract_number: "RM3830-FC0005-#{current_year}")
          create(:facilities_management_rm3830_procurement_further_competition, contract_number: "RM3830-FC0006-#{current_year}")
          create(:facilities_management_rm3830_procurement_further_competition, contract_number: 'RM3830-FC0007-2019')
          create(:facilities_management_rm3830_procurement_further_competition, contract_number: 'RM3830-FC0008-2019')
        end

        it 'presents all of the further competition contract numbers used for the current year' do
          expect(contract_number_generator.send(:used_contract_numbers_for_current_year).sort).to match(['0005', '0006'])
        end

        it 'does not present any of the further competition contract numbers used for the previous years' do
          expect(contract_number_generator.send(:used_contract_numbers_for_current_year).sort).not_to match(['0007', '0008'])
        end
      end

      context 'when the procurement is direct award eligable' do
        let(:model) { FacilitiesManagement::RM3830::ProcurementSupplier }

        before do
          create(:facilities_management_rm3830_procurement_supplier_da, contract_number: "RM3830-DA0001-#{current_year}")
          create(:facilities_management_rm3830_procurement_supplier_da, contract_number: "RM3830-DA0002-#{current_year}")
          create(:facilities_management_rm3830_procurement_supplier_da, contract_number: 'RM3830-DA0003-2019')
          create(:facilities_management_rm3830_procurement_supplier_da, contract_number: 'RM3830-DA0004-2019')
          create(:facilities_management_rm3830_procurement_supplier_fc, contract_number: "RM3830-FC0005-#{current_year}")
          create(:facilities_management_rm3830_procurement_supplier_fc, contract_number: "RM3830-FC0006-#{current_year}")
          create(:facilities_management_rm3830_procurement_supplier_fc, contract_number: 'RM3830-FC0007-2019')
          create(:facilities_management_rm3830_procurement_supplier_fc, contract_number: 'RM3830-FC0008-2019')
        end

        # rubocop:disable RSpec/NestedGroups
        context 'and the procurement state is direct award' do
          let(:procurement_state) { :direct_award }

          it 'presents all of the direct award contract numbers used for the current year' do
            expect(contract_number_generator.send(:used_contract_numbers_for_current_year).sort).to match(['0001', '0002'])
          end

          it 'does not present any of the direct award contract numbers used for the previous years' do
            expect(contract_number_generator.send(:used_contract_numbers_for_current_year).sort).not_to match(['0003', '0004'])
          end
        end

        context 'and the procurement state is further competition' do
          let(:procurement_state) { :further_competition }

          it 'presents all of the further competition contract numbers used for the current year' do
            expect(contract_number_generator.send(:used_contract_numbers_for_current_year).sort).to match(['0005', '0006'])
          end

          it 'does not present any of the further competition contract numbers used for the previous years' do
            expect(contract_number_generator.send(:used_contract_numbers_for_current_year).sort).not_to match(['0007', '0008'])
          end
        end
        # rubocop:enable RSpec/NestedGroups
      end
    end

    context 'when the framework is RM6232' do
      let(:contract_number_generator) { described_class.new(framework: 'RM6232', model: FacilitiesManagement::RM6232::Procurement) }
      let(:current_year) { Date.current.year.to_s }

      before do
        create(:facilities_management_rm6232_procurement, contract_number: "RM6232-000005-#{current_year}")
        create(:facilities_management_rm6232_procurement, contract_number: "RM6232-000006-#{current_year}")
        create(:facilities_management_rm6232_procurement, contract_number: 'RM6232-000007-2019')
        create(:facilities_management_rm6232_procurement, contract_number: 'RM6232-000008-2019')
      end

      it 'presents all of the contract numbers used for the current year' do
        expect(contract_number_generator.send(:used_contract_numbers_for_current_year).sort).to match(['000005', '000006'])
      end

      it 'does not present any of the contract numbers used for the previous years' do
        expect(contract_number_generator.send(:used_contract_numbers_for_current_year).sort).not_to match(['000007', '000008'])
      end
    end
  end
end
