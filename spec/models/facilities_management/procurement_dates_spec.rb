require 'rails_helper'

RSpec.describe FacilitiesManagement::Procurement, type: :model do
  subject(:procurement) { build(:facilities_management_procurement, mobilisation_period_required: false, extensions_required: false, contract_name: 'contract_period_test', user: user) }

  let(:user) { build(:user) }

  describe 'validating the contract length' do
    let(:initial_call_off_period_years) { 3 }
    let(:initial_call_off_period_months) { 3 }

    before do
      procurement.initial_call_off_period_years = initial_call_off_period_years
      procurement.initial_call_off_period_months = initial_call_off_period_months
    end

    context 'when considering just the years' do
      context 'and they are nil' do
        let(:initial_call_off_period_years) { nil }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to eq false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_period_years].first).to eq 'Enter the years for the initial call-off period'
        end
      end

      context 'and they are blank' do
        let(:initial_call_off_period_years) { '' }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to eq false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_period_years].first).to eq 'Enter the years for the initial call-off period'
        end
      end

      context 'and they are empty' do
        let(:initial_call_off_period_years) { '    ' }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to eq false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_period_years].first).to eq 'Enter the years for the initial call-off period'
        end
      end

      context 'and it is less than 0' do
        let(:initial_call_off_period_years) { -1 }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to eq false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_period_years].first).to eq 'The years for the initial call-off period must be between 0 and 7'
        end
      end

      context 'and it is greater than 7' do
        let(:initial_call_off_period_years) { 8 }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to eq false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_period_years].first).to eq 'The years for the initial call-off period must be between 0 and 7'
        end
      end

      context 'and it is not a number' do
        let(:initial_call_off_period_years) { 'TEN' }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to eq false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_period_years].first).to eq 'The years for the initial call-off period must be a whole number'
        end
      end

      context 'and it is a number bewteen 0 and 7' do
        it 'is valid' do
          expect(procurement.valid?(:contract_period)).to eq true
        end
      end
    end

    context 'when considering just the months' do
      context 'and they are nil' do
        let(:initial_call_off_period_months) { nil }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to eq false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_period_months].first).to eq 'Enter the months for the initial call-off period'
        end
      end

      context 'and they are blank' do
        let(:initial_call_off_period_months) { '' }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to eq false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_period_months].first).to eq 'Enter the months for the initial call-off period'
        end
      end

      context 'and they are empty' do
        let(:initial_call_off_period_months) { '    ' }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to eq false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_period_months].first).to eq 'Enter the months for the initial call-off period'
        end
      end

      context 'and it is less than 0' do
        let(:initial_call_off_period_months) { -1 }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to eq false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_period_months].first).to eq 'The months for the initial call-off period must be between 0 and 11'
        end
      end

      context 'and it is greater than 11' do
        let(:initial_call_off_period_months) { 12 }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to eq false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_period_months].first).to eq 'The months for the initial call-off period must be between 0 and 11'
        end
      end

      context 'and it is not a number' do
        let(:initial_call_off_period_months) { 'NINE' }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to eq false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_period_months].first).to eq 'The months for the initial call-off period must be a whole number'
        end
      end

      context 'and it is a number bewteen 0 and 11' do
        it 'is valid' do
          expect(procurement.valid?(:contract_period)).to eq true
        end
      end
    end

    context 'when considering the years and months together' do
      context 'and they are both 0' do
        let(:initial_call_off_period_years) { 0 }
        let(:initial_call_off_period_months) { 0 }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to eq false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:base].first).to eq 'The total initial call-off period must be between 1 month and 7 years'
        end
      end

      context 'and the total length is more than 7 years' do
        let(:initial_call_off_period_years) { 7 }
        let(:initial_call_off_period_months) { 1 }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to eq false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:base].first).to eq 'The total initial call-off period must be between 1 month and 7 years'
        end
      end

      context 'and the total length is 7 years' do
        let(:initial_call_off_period_years) { 7 }
        let(:initial_call_off_period_months) { 0 }

        it 'is valid' do
          expect(procurement.valid?(:contract_period)).to eq true
        end

        it 'has a contract length of 7 years' do
          expect(procurement.initial_call_off_period).to eq 7.years
        end
      end

      context 'and the total length is 1 month' do
        let(:initial_call_off_period_years) { 0 }
        let(:initial_call_off_period_months) { 1 }

        it 'is valid' do
          expect(procurement.valid?(:contract_period)).to eq true
        end

        it 'has a contract length of 1 month' do
          expect(procurement.initial_call_off_period).to eq 1.month
        end
      end

      context 'and the total length is between 1 month and 7 years' do
        it 'is valid' do
          expect(procurement.valid?(:contract_period)).to eq true
        end

        it 'has a contract length of 1 month' do
          expect(procurement.initial_call_off_period).to eq(3.years + 3.months)
        end
      end
    end
  end

  describe 'validating the initial call off start date' do
    let(:initial_call_off_start_date) { Time.zone.now + 1.day }
    let(:initial_call_off_start_date_yyyy) { initial_call_off_start_date.year.to_s }
    let(:initial_call_off_start_date_mm) { initial_call_off_start_date.month.to_s }
    let(:initial_call_off_start_date_dd) { initial_call_off_start_date.day.to_s }

    before do
      procurement.initial_call_off_start_date_yyyy = initial_call_off_start_date_yyyy
      procurement.initial_call_off_start_date_mm = initial_call_off_start_date_mm
      procurement.initial_call_off_start_date_dd = initial_call_off_start_date_dd
    end

    context 'when considering initial_call_off_start_date_yyyy and it is nil' do
      let(:initial_call_off_start_date_yyyy) { nil }

      it 'is not valid' do
        expect(procurement.valid?(:contract_period)).to eq false
      end

      it 'has the correct error message' do
        procurement.valid?(:contract_period)
        expect(procurement.errors[:initial_call_off_start_date].first).to eq 'Enter a valid initial call-off start date'
      end
    end

    context 'when considering initial_call_off_start_date_mm and it is blank' do
      let(:initial_call_off_start_date_mm) { '' }

      it 'is not valid' do
        expect(procurement.valid?(:contract_period)).to eq false
      end

      it 'has the correct error message' do
        procurement.valid?(:contract_period)
        expect(procurement.errors[:initial_call_off_start_date].first).to eq 'Enter a valid initial call-off start date'
      end
    end

    context 'when considering initial_call_off_start_date_dd and it is empty' do
      let(:initial_call_off_start_date_dd) { '    ' }

      it 'is not valid' do
        expect(procurement.valid?(:contract_period)).to eq false
      end

      it 'has the correct error message' do
        procurement.valid?(:contract_period)
        expect(procurement.errors[:initial_call_off_start_date].first).to eq 'Enter a valid initial call-off start date'
      end
    end

    context 'when considering the full initial_call_off_start_date' do
      context 'and it is in the past' do
        let(:initial_call_off_start_date) { Time.zone.now - 1.day }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to eq false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_start_date].first).to eq 'Initial call-off period start date must be today or in the future'
        end
      end

      context 'and it is after the end of 2099' do
        let(:initial_call_off_start_date) { Time.new(2100).in_time_zone('London') }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to eq false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_start_date].first).to eq 'Initial call-off period start date cannot be later than 31 December 2100'
        end
      end

      context 'and it is not a real date' do
        let(:initial_call_off_start_date_yyyy) { initial_call_off_start_date.year.to_s }
        let(:initial_call_off_start_date_mm) { '2' }
        let(:initial_call_off_start_date_dd) { '30' }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to eq false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_start_date].first).to eq 'Enter a valid initial call-off start date'
        end
      end

      context 'and it is a real date' do
        it 'is valid' do
          expect(procurement.valid?(:contract_period)).to eq true
        end
      end
    end
  end

  describe 'validating mobilisation period' do
    let(:initial_call_off_start_date) { Time.zone.now + 1.year }
    let(:tupe) { false }
    let(:mobilisation_period_required) { true }

    before do
      procurement.initial_call_off_start_date = initial_call_off_start_date
      procurement.tupe = tupe
      procurement.mobilisation_period_required = mobilisation_period_required
      procurement.mobilisation_period = mobilisation_period
    end

    context 'when TUPE is requred' do
      let(:tupe) { true }
      let(:mobilisation_period) { 6 }

      context 'and mobilisation period is false' do
        let(:mobilisation_period_required) { false }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to eq false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:mobilisation_period_required].first).to eq 'Mobilisation length must be a minimum of 4 weeks when TUPE is selected'
        end
      end

      context 'and mobilisation period is less than 4 weeks' do
        let(:mobilisation_period) { 3 }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to eq false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:mobilisation_period].first).to eq 'Mobilisation length must be a minimum of 4 weeks when TUPE is selected'
        end
      end

      context 'and mobilisation period is more than 52 weeks' do
        let(:mobilisation_period) { 53 }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to eq false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:mobilisation_period].first).to eq 'Mobilisation length must be between 1 and 52 weeks'
        end
      end

      context 'and mobilisation period is more than 4 weeks' do
        it 'is valid' do
          expect(procurement.valid?(:contract_period)).to eq true
        end
      end
    end

    context 'when TUPE is not requred' do
      let(:mobilisation_period) { 3 }

      context 'and mobilisation period is nil' do
        let(:mobilisation_period_required) { nil }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to eq false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:mobilisation_period_required].first).to eq 'Select one option for mobilisation period'
        end
      end

      context 'and mobilisation period is false' do
        let(:mobilisation_period_required) { false }

        it 'is valid' do
          expect(procurement.valid?(:contract_period)).to eq true
        end
      end

      context 'and mobilisation period is nil' do
        let(:mobilisation_period) { nil }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to eq false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:mobilisation_period].first).to eq 'Enter mobilisation period length'
        end
      end

      context 'and mobilisation period is 0 weeks' do
        let(:mobilisation_period) { 0 }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to eq false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:mobilisation_period].first).to eq 'Mobilisation length must be between 1 and 52 weeks'
        end
      end

      context 'and mobilisation period is more than 52 weeks' do
        let(:mobilisation_period) { 53 }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to eq false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:mobilisation_period].first).to eq 'Mobilisation length must be between 1 and 52 weeks'
        end
      end

      context 'and it is more than 0 weeks' do
        it 'is valid' do
          expect(procurement.valid?(:contract_period)).to eq true
        end
      end
    end

    context 'when the mobilisation period start date is in the past' do
      let(:initial_call_off_start_date) { Time.zone.now + 5.weeks + 1.day }
      let(:mobilisation_period) { 5 }

      it 'is not valid' do
        expect(procurement.valid?(:contract_period)).to eq false
      end

      it 'has the correct error message' do
        procurement.valid?(:contract_period)
        expect(procurement.errors[:mobilisation_start_date].first).to eq "Mobilisation start date must be in the future, please review your 'Initial call-off-period' and 'Mobilisation period length'"
      end
    end

    context 'when the mobilisation period start date is in the future' do
      let(:initial_call_off_start_date) { Time.zone.now + 5.weeks + 2.days }
      let(:mobilisation_period) { 5 }

      it 'is valid' do
        expect(procurement.valid?(:contract_period)).to eq true
      end
    end
  end

  describe 'validations for optional call of extensions' do
    let(:optional_call_off_extensions_1) { 1 }
    let(:optional_call_off_extensions_2) { nil }
    let(:optional_call_off_extensions_3) { nil }
    let(:optional_call_off_extensions_4) { nil }
    let(:call_off_extension_2) { 'false' }
    let(:call_off_extension_3) { 'false' }
    let(:call_off_extension_4) { 'false' }

    before do
      procurement.mobilisation_period_required = false
      procurement.initial_call_off_period_years = 7
      procurement.initial_call_off_period_months = 0
      procurement.extensions_required = true
      procurement.call_off_extension_2 = call_off_extension_2
      procurement.call_off_extension_3 = call_off_extension_3
      procurement.call_off_extension_4 = call_off_extension_4
      procurement.optional_call_off_extensions_1 = optional_call_off_extensions_1
      procurement.optional_call_off_extensions_2 = optional_call_off_extensions_2
      procurement.optional_call_off_extensions_3 = optional_call_off_extensions_3
      procurement.optional_call_off_extensions_4 = optional_call_off_extensions_4
    end

    context 'when the first optional period is left blank' do
      let(:optional_call_off_extensions_1) { nil }

      it 'is not valid' do
        expect(procurement.valid?(:contract_period)).to eq false
      end

      it 'has the correct error message' do
        procurement.valid?(:contract_period)
        expect(procurement.errors[:optional_call_off_extensions_1].first).to eq 'Enter extension period'
      end
    end

    context 'when the total period is more than 10' do
      let(:optional_call_off_extensions_1) { 4 }

      it 'is not valid' do
        expect(procurement.valid?(:contract_period)).to eq false
      end

      it 'has the correct error message' do
        procurement.valid?(:contract_period)
        expect(procurement.errors[:optional_call_off_extensions_1].first).to eq 'Call-off contract period, including extensions, must not be more than 10 years in total'
      end
    end

    context 'when the total period is more than 10 with two periods' do
      let(:optional_call_off_extensions_1) { 2 }
      let(:optional_call_off_extensions_2) { 2 }
      let(:call_off_extension_2) { 'true' }

      it 'is not valid' do
        expect(procurement.valid?(:contract_period)).to eq false
      end

      it 'has the correct error message' do
        procurement.valid?(:contract_period)
        expect(procurement.errors[:optional_call_off_extensions_1].first).to eq 'Call-off contract period, including extensions, must not be more than 10 years in total'
      end
    end

    context 'when optional_call_off_extensions even though they have not been added' do
      let(:optional_call_off_extensions_1) { 1 }
      let(:optional_call_off_extensions_2) { 'a' }
      let(:optional_call_off_extensions_3) { 'a' }
      let(:optional_call_off_extensions_4) { 'a' }

      it 'is not valid' do
        expect(procurement.valid?(:contract_period)).to eq false
      end
    end

    context 'when second extension is nil but the third is not' do
      let(:optional_call_off_extensions_1) { 1 }
      let(:optional_call_off_extensions_3) { 1 }
      let(:call_off_extension_3) { 'true' }

      before do
        procurement.call_off_extension_2 = 'false'
        procurement.call_off_extension_3 = 'true'
        procurement.call_off_extension_4 = 'false'
        procurement.optional_call_off_extensions_1 = 1
        procurement.optional_call_off_extensions_3 = 1
      end

      it 'is not valid' do
        expect(procurement.valid?(:contract_period)).to eq false
      end
    end

    context 'when the third extension is nil but the forth is not' do
      let(:optional_call_off_extensions_1) { 1 }
      let(:optional_call_off_extensions_4) { 1 }
      let(:call_off_extension_4) { 'true' }

      before do
        procurement.call_off_extension_2 = 'false'
        procurement.call_off_extension_3 = 'false'
        procurement.call_off_extension_4 = 'true'
        procurement.optional_call_off_extensions_1 = 1
        procurement.optional_call_off_extensions_4 = 1
      end

      it 'is not valid' do
        expect(procurement.valid?(:contract_period)).to eq false
      end
    end

    context 'when the total with one extension is 10 years or less' do
      let(:optional_call_off_extensions_1) { 1 }

      it 'is valid' do
        expect(procurement.valid?(:contract_period)).to eq true
      end
    end

    context 'when the total with multiple extensions is 10 years or less' do
      let(:optional_call_off_extensions_1) { 1 }
      let(:optional_call_off_extensions_2) { 1 }
      let(:optional_call_off_extensions_3) { 1 }
      let(:call_off_extension_2) { 'true' }
      let(:call_off_extension_3) { 'true' }

      it 'is valid' do
        expect(procurement.valid?(:contract_period)).to eq true
      end
    end
  end
end
