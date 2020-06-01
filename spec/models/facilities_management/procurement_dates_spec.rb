require 'rails_helper'

RSpec.describe FacilitiesManagement::Procurement, type: :model do
  subject(:procurement) { build(:facilities_management_procurement, contract_name: 'contract_dates_test', user: user) }

  let(:user) { build(:user) }

  describe 'contract data should not be invalid because call-off period is not > 0' do
    context 'when the initial_call_off_period is not supplied' do
      it 'will be invalid' do
        procurement.save context: :contract_dates
        expect(procurement.valid?(:contract_dates)).to eq false
      end
    end

    context 'when the initial_call_off_period is set to Nil' do
      it 'will be invalid because of a blank error' do
        procurement.initial_call_off_period = nil
        procurement.save context: :contract_dates
        expect(procurement.valid?(:contract_dates)).to eq false
        expect(procurement.errors[:initial_call_off_period][0]).to eq 'Enter initial call-off period'
      end
    end

    context 'when initial_call_off_period is an empty string or whitespace' do
      it 'will be invalid ' do
        procurement.initial_call_off_period = ''
        procurement.save context: :contract_dates
        expect(procurement.valid?(:contract_dates)).to eq false
        procurement.initial_call_off_period = '     '
        procurement.save context: :contract_dates
        expect(procurement.valid?(:contract_dates)).to eq false
      end
    end

    context 'when initial_call_off_period is < 0' do
      it 'will be invalid' do
        procurement.initial_call_off_period = -2
        procurement.save context: :contract_dates
        expect(procurement.errors.details[:initial_call_off_period][0][:error]).to eq :greater_than_or_equal_to
        expect(procurement.valid?(:contract_dates)).to eq false
      end
    end

    context 'when initial_call_off_period is == 0' do
      it 'will be valid' do
        procurement.initial_call_off_period = 0
        procurement.save context: :contract_dates
        expect(procurement.valid?(:contract_dates)).to eq false
      end
    end
  end

  describe 'when a call off period is specified, other validation rules will come into effect, ' do
    context 'when mobilisation period is zero' do
      it 'and will be valid' do
        procurement.initial_call_off_period = 1
        procurement.mobilisation_period = 0
        procurement.save context: :contract_dates
        expect(procurement.errors.details[:initial_call_off_start_date][0][:error]).to eq :not_a_date
        expect(procurement.valid?(:contract_dates)).to eq false
      end
    end

    describe 'and when mob period is > 0, then further rules come into play:' do
      context 'when mob period is 1' do
        it 'will be invalid' do
          procurement.initial_call_off_period = 1
          procurement.mobilisation_period = 1
          procurement.save context: :contract_dates
          expect(procurement.errors.details[:initial_call_off_start_date][0][:error]).to eq :not_a_date
          expect(procurement.valid?(:contract_dates)).to eq false
        end
      end

      context 'when the contract_start_date needs to be populated' do
        it 'will be invalid if the date is nil' do
          procurement.initial_call_off_period = 1
          procurement.tupe = false
          procurement.mobilisation_period = 1
          procurement.initial_call_off_start_date = nil
          procurement.save context: :contract_dates
          expect(procurement.errors.details[:initial_call_off_start_date][0][:error]).to eq :not_a_date
          expect(procurement.valid?(:contract_dates)).to eq false
        end
        it 'will be invalid if the date is the wrong format or empty' do
          procurement.initial_call_off_period = 1
          procurement.tupe = false
          procurement.mobilisation_period = 1
          procurement.initial_call_off_start_date = ''
          procurement.save context: :contract_dates
          expect(procurement.errors.details[:initial_call_off_start_date][0][:error]).to eq :not_a_date
          expect(procurement.valid?(:contract_dates)).to eq false
        end
        it 'will be invalid if the date is before now' do
          procurement.initial_call_off_period = 1
          procurement.tupe = false
          procurement.mobilisation_period = 1
          procurement.initial_call_off_start_date = DateTime.current - 100
          procurement.initial_call_off_end_date = DateTime.current - 100
          procurement.save context: :contract_dates
          expect(procurement.errors.details[:initial_call_off_start_date][0][:error]).to eq :date_after_or_equal_to
          expect(procurement.valid?(:contract_dates)).to eq false
        end
        it 'will be valid if the date is after now' do
          procurement.initial_call_off_period = 1
          procurement.tupe = false
          procurement.mobilisation_period_required = true
          procurement.mobilisation_period = 1
          procurement.initial_call_off_start_date = DateTime.current + 100
          procurement.initial_call_off_end_date = DateTime.current + 200
          procurement.extensions_required = false
          procurement.save context: :contract_dates
          expect(procurement.valid?(:contract_dates)).to eq true
        end
      end

      context 'when TUPE is specified' do
        it 'will be valid when mob period is 1 and TUPE is false' do
          procurement.initial_call_off_period = 1
          procurement.tupe = false
          procurement.mobilisation_period_required = true
          procurement.mobilisation_period = 1
          procurement.initial_call_off_start_date = DateTime.current + 100
          procurement.initial_call_off_end_date = DateTime.current + 200
          procurement.extensions_required = false
          procurement.save context: :contract_dates
          expect(procurement.valid?(:contract_dates)).to eq true
        end
        it 'will be invalid when mob period is 1 and TUPE is true' do
          procurement.initial_call_off_period = 1
          procurement.tupe = true
          procurement.mobilisation_period_required = true
          procurement.mobilisation_period = 1
          procurement.initial_call_off_start_date = DateTime.current + 100
          procurement.initial_call_off_end_date = DateTime.current + 200
          procurement.save context: :contract_dates
          expect(procurement.errors.details[:mobilisation_period][0][:error]).to eq :greater_than_or_equal_to
          expect(procurement.valid?(:contract_dates)).to eq false
        end
        it 'will be valid when mob period is 4 and TUPE is true' do
          procurement.initial_call_off_period = 1
          procurement.tupe = true
          procurement.mobilisation_period_required = true
          procurement.mobilisation_period = 4
          procurement.initial_call_off_start_date = DateTime.current + 100
          procurement.initial_call_off_end_date = DateTime.current + 200
          procurement.extensions_required = false
          procurement.save context: :contract_dates
          expect(procurement.valid?(:contract_dates)).to eq true
        end
        it 'will be invalid when mob period is greater than 52 and TUPE is false' do
          procurement.initial_call_off_period = 1
          procurement.tupe = false
          procurement.mobilisation_period_required = true
          procurement.mobilisation_period = 53
          procurement.initial_call_off_start_date = DateTime.current + 100
          procurement.initial_call_off_end_date = DateTime.current + 200
          procurement.extensions_required = false
          procurement.save context: :contract_dates
          expect(procurement.errors.details[:mobilisation_period][0][:error]).to eq :less_than_or_equal_to
          expect(procurement.valid?(:contract_dates)).to eq false
        end
        it 'will be invalid when mob period is greater than 52 and TUPE is true' do
          procurement.initial_call_off_period = 1
          procurement.tupe = true
          procurement.mobilisation_period_required = true
          procurement.mobilisation_period = 53
          procurement.initial_call_off_start_date = DateTime.current + 100
          procurement.initial_call_off_end_date = DateTime.current + 200
          procurement.extensions_required = false
          procurement.save context: :contract_dates
          expect(procurement.errors.details[:mobilisation_period][0][:error]).to eq :less_than_or_equal_to
          expect(procurement.valid?(:contract_dates)).to eq false
        end
        it 'will be invalid when mob period start date is not in the future' do
          procurement.initial_call_off_period = 1
          procurement.tupe = false
          procurement.mobilisation_period_required = true
          procurement.mobilisation_period = 5
          procurement.initial_call_off_start_date = DateTime.current
          procurement.initial_call_off_end_date = DateTime.current + 200
          procurement.extensions_required = false
          procurement.save context: :contract_dates
          expect(procurement.errors.details[:mobilisation_start_date][0][:error]).to eq :greater_than
          expect(procurement.valid?(:contract_dates)).to eq false
        end
      end
      # rubocop:disable RSpec/NestedGroups

      describe 'and when optional call-off contract is selected, then further rules come into play:' do
        before do
          procurement.initial_call_off_period = 7
          procurement.initial_call_off_start_date = DateTime.current + 100
          procurement.initial_call_off_end_date = DateTime.current + 200
          procurement.tupe = false
          procurement.mobilisation_period_required = false
          procurement.extensions_required = true
        end

        context 'when optional call-off contract is present' do
          it 'will be invalid when it blank' do
            procurement.save context: :contract_dates
            expect(procurement.errors.details[:optional_call_off_extensions_1][0][:error]).to eq :blank
            expect(procurement.valid?(:contract_dates)).to eq false
          end
          it 'will be valid when the total_extensions is 10' do
            procurement.optional_call_off_extensions_1 = 3
            procurement.call_off_extension_2 = 'false'
            procurement.call_off_extension_3 = 'false'
            procurement.call_off_extension_4 = 'false'
            procurement.save context: :contract_dates
            expect(procurement.valid?(:contract_dates)).to eq true
          end
          it 'will be invalid when the total_extensions is 11' do
            procurement.optional_call_off_extensions_1 = 4
            procurement.save context: :contract_dates
            expect(procurement.errors.details[:optional_call_off_extensions_1][0][:error]).to eq :too_long
            expect(procurement.valid?(:contract_dates)).to eq false
          end
          it 'will be invalid when the total_extensions is 11 with 2 extension inplace' do
            procurement.optional_call_off_extensions_1 = 3
            procurement.optional_call_off_extensions_2 = 1
            procurement.save context: :contract_dates
            expect(procurement.errors.details[:optional_call_off_extensions_1][0][:error]).to eq :too_long
            expect(procurement.valid?(:contract_dates)).to eq false
          end
        end

        context 'when optional_call_off_extensions are present even when not selected' do
          it 'will not be valid even though call_off_extension are false' do
            procurement.call_off_extension_2 = 'false'
            procurement.call_off_extension_3 = 'false'
            procurement.call_off_extension_4 = 'false'
            procurement.optional_call_off_extensions_1 = 1
            procurement.optional_call_off_extensions_2 = 'a'
            procurement.optional_call_off_extensions_3 = 'a'
            procurement.optional_call_off_extensions_4 = 'a'
            expect(procurement.valid?(:contract_dates)).to eq false
          end
        end

        context 'when the second extension is nil but the third is not' do
          it 'will not be valid' do
            procurement.call_off_extension_2 = 'false'
            procurement.call_off_extension_3 = 'true'
            procurement.call_off_extension_4 = 'false'
            procurement.optional_call_off_extensions_1 = 1
            procurement.optional_call_off_extensions_3 = 1
            expect(procurement.valid?(:contract_dates)).to eq false
          end
        end

        context 'when the third extension is nil but the forth is not' do
          it 'will not be valid' do
            procurement.call_off_extension_2 = 'false'
            procurement.call_off_extension_3 = 'false'
            procurement.call_off_extension_4 = 'true'
            procurement.optional_call_off_extensions_1 = 1
            procurement.optional_call_off_extensions_4 = 1
            expect(procurement.valid?(:contract_dates)).to eq false
          end
        end
      end
      # rubocop:enable RSpec/NestedGroups
    end
  end
end
