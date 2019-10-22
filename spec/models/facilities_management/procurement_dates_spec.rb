require 'rails_helper'

RSpec.describe FacilitiesManagement::Procurement, type: :model do
  subject(:procurement) { build(:facilities_management_procurement, name: 'contract_dates_test', user: user) }

  let(:user) { build(:user) }

  def log_error
  end
  # puts $stdout, "Messages: #{procurement.errors.to_json}"
  # puts $stdout, "Details: #{procurement.errors.details.to_json}"

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
        log_error
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
        log_error
        expect(procurement.errors.details[:initial_call_off_period][0][:error]).to eq :greater_than_or_equal_to
        expect(procurement.valid?(:contract_dates)).to eq false
      end
    end

    context 'when initial_call_off_period is == 0' do
      it 'will be valid' do
        procurement.initial_call_off_period = 0
        procurement.save context: :contract_dates
        log_error
        expect(procurement.valid?(:contract_dates)).to eq true
      end
    end
  end

  describe 'when a call off period is specified, other validation rules will come into effect, ' do
    context 'when initial_call_off_period is > 0' do
      it 'will be invalid' do
        procurement.initial_call_off_period = 1
        procurement.save context: :contract_dates
        log_error
        expect(procurement.errors.details[:mobilisation_period][0][:error]).to eq :not_a_number
        expect(procurement.valid?(:contract_dates)).to eq false
      end
    end

    context 'when mobilisation period is nil or whitespace' do
      it 'and will be invalid when the value is nil' do
        procurement.initial_call_off_period = 1
        procurement.mobilisation_period = nil
        procurement.save context: :contract_dates
        log_error
        expect(procurement.errors.details[:mobilisation_period][0][:error]).to eq :not_a_number
        expect(procurement.valid?(:contract_dates)).to eq false
      end

      it 'and will be invalid when the value is whitespace' do
        procurement.initial_call_off_period = 1
        procurement.mobilisation_period = '    '
        procurement.save context: :contract_dates
        log_error
        expect(procurement.errors.details[:mobilisation_period][0][:error]).to eq :not_a_number
        expect(procurement.valid?(:contract_dates)).to eq false
      end
    end

    context 'when mobilisation period is zero' do
      it 'and will be valid' do
        procurement.initial_call_off_period = 1
        procurement.mobilisation_period = 0
        procurement.save context: :contract_dates
        log_error
        expect(procurement.errors.details[:initial_call_off_start_date][0][:error]).to eq :blank
        expect(procurement.valid?(:contract_dates)).to eq false
      end
    end

    describe 'and when mob period is > 0, then further rules come into play:' do
      context 'when mob period is 1' do
        it 'will be invalid' do
          procurement.initial_call_off_period = 1
          procurement.mobilisation_period = 1
          procurement.save context: :contract_dates
          log_error
          expect(procurement.errors.details[:initial_call_off_start_date][0][:error]).to eq :blank
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
          log_error
          expect(procurement.errors.details[:initial_call_off_start_date][0][:error]).to eq :blank
          expect(procurement.valid?(:contract_dates)).to eq false
        end
        it 'will be invalid if the date is the wrong format or empty' do
          procurement.initial_call_off_period = 1
          procurement.tupe = false
          procurement.mobilisation_period = 1
          procurement.initial_call_off_start_date = ''
          procurement.save context: :contract_dates
          log_error
          expect(procurement.errors.details[:initial_call_off_start_date][0][:error]).to eq :blank
          expect(procurement.valid?(:contract_dates)).to eq false
        end
        it 'will be invalid if the date is before now' do
          procurement.initial_call_off_period = 1
          procurement.tupe = false
          procurement.mobilisation_period = 1
          procurement.initial_call_off_start_date = DateTime.current - 100
          procurement.initial_call_off_end_date = DateTime.current - 10
          procurement.save context: :contract_dates
          log_error
          expect(procurement.errors.details[:initial_call_off_start_date][0][:error]).to eq :after
          expect(procurement.valid?(:contract_dates)).to eq false
        end
        it 'will be valid if the date is after now' do
          procurement.initial_call_off_period = 1
          procurement.tupe = false
          procurement.mobilisation_period = 1
          procurement.initial_call_off_start_date = DateTime.current + 100
          procurement.initial_call_off_end_date = DateTime.current + 200
          procurement.save context: :contract_dates
          expect(procurement.valid?(:contract_dates)).to eq true
        end
      end

      context 'when TUPE is specified' do
        it 'will be valid when mob period is 1 and TUPE is false' do
          procurement.initial_call_off_period = 1
          procurement.tupe = false
          procurement.mobilisation_period = 1
          procurement.initial_call_off_start_date = DateTime.current + 100
          procurement.initial_call_off_end_date = DateTime.current + 200
          procurement.save context: :contract_dates
          expect(procurement.valid?(:contract_dates)).to eq true
        end
        it 'will be invalid when mob period is 1 and TUPE is true' do
          procurement.initial_call_off_period = 1
          procurement.tupe = true
          procurement.mobilisation_period = 1
          procurement.initial_call_off_start_date = DateTime.current + 100
          procurement.initial_call_off_end_date = DateTime.current + 200
          procurement.save context: :contract_dates
          log_error
          expect(procurement.errors.details[:mobilisation_period][0][:error]).to eq :greater_than_or_equal_to
          expect(procurement.valid?(:contract_dates)).to eq false
        end
        it 'will be valid when mob period is 4 and TUPE is true' do
          procurement.initial_call_off_period = 1
          procurement.tupe = true
          procurement.mobilisation_period = 4
          procurement.initial_call_off_start_date = DateTime.current + 100
          procurement.initial_call_off_end_date = DateTime.current + 200
          procurement.save context: :contract_dates
          log_error
          expect(procurement.valid?(:contract_dates)).to eq true
        end
      end
    end
  end
end
