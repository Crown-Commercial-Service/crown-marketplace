require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Procurement do
  subject(:procurement) { build(:facilities_management_rm3830_procurement, mobilisation_period_required: false, extensions_required: false, contract_name: 'contract_period_test', user: user) }

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
          expect(procurement.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_period_years].first).to eq 'Enter the years for the initial call-off period'
        end
      end

      context 'and they are blank' do
        let(:initial_call_off_period_years) { '' }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_period_years].first).to eq 'Enter the years for the initial call-off period'
        end
      end

      context 'and they are empty' do
        let(:initial_call_off_period_years) { '    ' }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_period_years].first).to eq 'Enter the years for the initial call-off period'
        end
      end

      context 'and it is less than 0' do
        let(:initial_call_off_period_years) { -1 }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_period_years].first).to eq 'The years for the initial call-off period must be between 0 and 7'
        end
      end

      context 'and it is greater than 7' do
        let(:initial_call_off_period_years) { 8 }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_period_years].first).to eq 'The years for the initial call-off period must be between 0 and 7'
        end
      end

      context 'and it is not a number' do
        let(:initial_call_off_period_years) { 'TEN' }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_period_years].first).to eq 'The years for the initial call-off period must be a whole number'
        end
      end

      context 'and it is a number between 0 and 7' do
        it 'is valid' do
          expect(procurement.valid?(:contract_period)).to be true
        end
      end
    end

    context 'when considering just the months' do
      context 'and they are nil' do
        let(:initial_call_off_period_months) { nil }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_period_months].first).to eq 'Enter the months for the initial call-off period'
        end
      end

      context 'and they are blank' do
        let(:initial_call_off_period_months) { '' }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_period_months].first).to eq 'Enter the months for the initial call-off period'
        end
      end

      context 'and they are empty' do
        let(:initial_call_off_period_months) { '    ' }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_period_months].first).to eq 'Enter the months for the initial call-off period'
        end
      end

      context 'and it is less than 0' do
        let(:initial_call_off_period_months) { -1 }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_period_months].first).to eq 'The months for the initial call-off period must be between 0 and 11'
        end
      end

      context 'and it is greater than 11' do
        let(:initial_call_off_period_months) { 12 }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_period_months].first).to eq 'The months for the initial call-off period must be between 0 and 11'
        end
      end

      context 'and it is not a number' do
        let(:initial_call_off_period_months) { 'NINE' }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_period_months].first).to eq 'The months for the initial call-off period must be a whole number'
        end
      end

      context 'and it is a number between 0 and 11' do
        it 'is valid' do
          expect(procurement.valid?(:contract_period)).to be true
        end
      end
    end

    context 'when considering the years and months together' do
      context 'and they are both 0' do
        let(:initial_call_off_period_years) { 0 }
        let(:initial_call_off_period_months) { 0 }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to be false
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
          expect(procurement.valid?(:contract_period)).to be false
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
          expect(procurement.valid?(:contract_period)).to be true
        end

        it 'has a contract length of 7 years' do
          expect(procurement.initial_call_off_period).to eq 7.years
        end
      end

      context 'and the total length is 1 month' do
        let(:initial_call_off_period_years) { 0 }
        let(:initial_call_off_period_months) { 1 }

        it 'is valid' do
          expect(procurement.valid?(:contract_period)).to be true
        end

        it 'has a contract length of 1 month' do
          expect(procurement.initial_call_off_period).to eq 1.month
        end
      end

      context 'and the total length is between 1 month and 7 years' do
        it 'is valid' do
          expect(procurement.valid?(:contract_period)).to be true
        end

        it 'has a contract length of 1 month' do
          expect(procurement.initial_call_off_period).to eq(3.years + 3.months)
        end
      end
    end
  end

  describe 'validating the initial call off start date' do
    let(:initial_call_off_start_date) { 1.day.from_now }
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
        expect(procurement.valid?(:contract_period)).to be false
      end

      it 'has the correct error message' do
        procurement.valid?(:contract_period)
        expect(procurement.errors[:initial_call_off_start_date].first).to eq 'Enter a valid initial call-off start date'
      end
    end

    context 'when considering initial_call_off_start_date_mm and it is blank' do
      let(:initial_call_off_start_date_mm) { '' }

      it 'is not valid' do
        expect(procurement.valid?(:contract_period)).to be false
      end

      it 'has the correct error message' do
        procurement.valid?(:contract_period)
        expect(procurement.errors[:initial_call_off_start_date].first).to eq 'Enter a valid initial call-off start date'
      end
    end

    context 'when considering initial_call_off_start_date_dd and it is empty' do
      let(:initial_call_off_start_date_dd) { '    ' }

      it 'is not valid' do
        expect(procurement.valid?(:contract_period)).to be false
      end

      it 'has the correct error message' do
        procurement.valid?(:contract_period)
        expect(procurement.errors[:initial_call_off_start_date].first).to eq 'Enter a valid initial call-off start date'
      end
    end

    context 'when considering the full initial_call_off_start_date' do
      context 'and it is in the past' do
        let(:initial_call_off_start_date) { 1.day.ago }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_start_date].first).to eq 'Initial call-off period start date must be today or in the future'
        end
      end

      context 'and it is after the end of 2099' do
        let(:initial_call_off_start_date) { Time.new(2100).in_time_zone('London') }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to be false
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
          expect(procurement.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:initial_call_off_start_date].first).to eq 'Enter a valid initial call-off start date'
        end
      end

      context 'and it is a real date' do
        it 'is valid' do
          expect(procurement.valid?(:contract_period)).to be true
        end
      end
    end
  end

  describe 'validating mobilisation period' do
    let(:initial_call_off_start_date) { 1.year.from_now }
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
          expect(procurement.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:mobilisation_period_required].first).to eq 'Mobilisation length must be a minimum of 4 weeks when TUPE is selected'
        end
      end

      context 'and mobilisation period is less than 4 weeks' do
        let(:mobilisation_period) { 3 }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:mobilisation_period].first).to eq 'Mobilisation length must be a minimum of 4 weeks when TUPE is selected'
        end
      end

      context 'and mobilisation period is more than 52 weeks' do
        let(:mobilisation_period) { 53 }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:mobilisation_period].first).to eq 'Mobilisation length must be between 1 and 52 weeks'
        end
      end

      context 'and mobilisation period is more than 4 weeks' do
        it 'is valid' do
          expect(procurement.valid?(:contract_period)).to be true
        end
      end
    end

    context 'when TUPE is not requred' do
      let(:mobilisation_period) { 3 }

      context 'and mobilisation period required is nil' do
        let(:mobilisation_period_required) { nil }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:mobilisation_period_required].first).to eq 'Select one option for mobilisation period'
        end
      end

      context 'and mobilisation period is false' do
        let(:mobilisation_period_required) { false }

        it 'is valid' do
          expect(procurement.valid?(:contract_period)).to be true
        end
      end

      context 'and mobilisation period is nil' do
        let(:mobilisation_period) { nil }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:mobilisation_period].first).to eq 'Enter mobilisation period length'
        end
      end

      context 'and mobilisation period is 0 weeks' do
        let(:mobilisation_period) { 0 }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:mobilisation_period].first).to eq 'Mobilisation length must be between 1 and 52 weeks'
        end
      end

      context 'and mobilisation period is more than 52 weeks' do
        let(:mobilisation_period) { 53 }

        it 'is not valid' do
          expect(procurement.valid?(:contract_period)).to be false
        end

        it 'has the correct error message' do
          procurement.valid?(:contract_period)
          expect(procurement.errors[:mobilisation_period].first).to eq 'Mobilisation length must be between 1 and 52 weeks'
        end
      end

      context 'and it is more than 0 weeks' do
        it 'is valid' do
          expect(procurement.valid?(:contract_period)).to be true
        end
      end
    end

    context 'when the mobilisation period start date is in the past' do
      let(:initial_call_off_start_date) { 5.weeks.from_now + 1.day }
      let(:mobilisation_period) { 5 }

      it 'is not valid' do
        expect(procurement.valid?(:contract_period)).to be false
      end

      it 'has the correct error message' do
        procurement.valid?(:contract_period)
        expect(procurement.errors[:mobilisation_start_date].first).to eq "Mobilisation start date must be in the future, please review your 'Initial call-off-period' and 'Mobilisation period length'"
      end
    end

    context 'when the mobilisation period start date is in the future' do
      let(:initial_call_off_start_date) { 5.weeks.from_now + 2.days }
      let(:mobilisation_period) { 5 }

      it 'is valid' do
        expect(procurement.valid?(:contract_period)).to be true
      end
    end
  end

  # rubocop:disable RSpec/NestedGroups
  describe 'validations for the total period' do
    let(:mobilisation_period_required) { false }

    before do
      procurement.initial_call_off_period_years = 3
      procurement.initial_call_off_period_months = 4
      procurement.mobilisation_period_required = mobilisation_period_required
      procurement.mobilisation_period = mobilisation_period if mobilisation_period_required

      procurement.extensions_required = true
      procurement.assign_attributes(call_off_extensions_attributes: extension_details)
    end

    context 'with only optional call of extensions' do
      context 'and the total is just more than 10 years' do
        context 'and there is 1 extension period' do
          let(:extension_details) do
            [
              { extension: 0, years: 6, months: 9, extension_required: 'true' },
              { extension: 1, years: nil, months: nil, extension_required: 'false' },
              { extension: 2, years: nil, months: nil, extension_required: 'false' },
              { extension: 3, years: nil, months: nil, extension_required: 'false' }
            ]
          end

          it 'is not valid' do
            expect(procurement.valid?(:contract_period)).to be false
          end

          it 'has the correct error message' do
            procurement.valid?(:contract_period)
            expect(procurement.errors[:base].first).to eq 'Call-off contract period, including extensions and mobilisation period, must not be more than 10 years in total'
          end
        end

        context 'and there are 2 extension period' do
          let(:extension_details) do
            [
              { extension: 0, years: 3, months: 11, extension_required: 'true' },
              { extension: 1, years: 2, months: 10, extension_required: 'true' },
              { extension: 2, years: nil, months: nil, extension_required: 'false' },
              { extension: 3, years: nil, months: nil, extension_required: 'false' }
            ]
          end

          it 'is not valid' do
            expect(procurement.valid?(:contract_period)).to be false
          end

          it 'has the correct error message' do
            procurement.valid?(:contract_period)
            expect(procurement.errors[:base].first).to eq 'Call-off contract period, including extensions and mobilisation period, must not be more than 10 years in total'
          end
        end

        context 'and there are 3 extension period' do
          let(:extension_details) do
            [
              { extension: 0, years: 1, months: 10, extension_required: 'true' },
              { extension: 1, years: 2, months: 1, extension_required: 'true' },
              { extension: 2, years: 2, months: 10, extension_required: 'true' },
              { extension: 3, years: nil, months: nil, extension_required: 'false' }
            ]
          end

          it 'is not valid' do
            expect(procurement.valid?(:contract_period)).to be false
          end

          it 'has the correct error message' do
            procurement.valid?(:contract_period)
            expect(procurement.errors[:base].first).to eq 'Call-off contract period, including extensions and mobilisation period, must not be more than 10 years in total'
          end
        end

        context 'and there are 4 extension period' do
          let(:extension_details) do
            [
              { extension: 0, years: 1, months: 5, extension_required: 'true' },
              { extension: 1, years: 1, months: 10, extension_required: 'true' },
              { extension: 2, years: 1, months: 8, extension_required: 'true' },
              { extension: 3, years: 1, months: 10, extension_required: 'true' }
            ]
          end

          it 'is not valid' do
            expect(procurement.valid?(:contract_period)).to be false
          end

          it 'has the correct error message' do
            procurement.valid?(:contract_period)
            expect(procurement.errors[:base].first).to eq 'Call-off contract period, including extensions and mobilisation period, must not be more than 10 years in total'
          end
        end
      end

      context 'and the total is just less than 10 years' do
        context 'and there are 2 extension period' do
          let(:extension_details) do
            [
              { extension: 0, years: 1, months: 10, extension_required: 'true' },
              { extension: 1, years: 2, months: 0, extension_required: 'true' },
              { extension: 2, years: nil, months: nil, extension_required: 'false' },
              { extension: 3, years: nil, months: nil, extension_required: 'false' }
            ]
          end

          it 'is valid' do
            expect(procurement.valid?(:contract_period)).to be true
          end
        end

        context 'and there are 4 extension period' do
          let(:extension_details) do
            [
              { extension: 0, years: 1, months: 0, extension_required: 'true' },
              { extension: 1, years: 1, months: 5, extension_required: 'true' },
              { extension: 2, years: 1, months: 5, extension_required: 'true' },
              { extension: 3, years: 2, months: 10, extension_required: 'true' }
            ]
          end

          it 'is valid' do
            expect(procurement.valid?(:contract_period)).to be true
          end
        end
      end
    end

    context 'with both mobilisation period and optional call of extensions' do
      let(:mobilisation_period_required) { true }

      context 'and the total is just more than 10 years' do
        context 'and there is 1 extension period' do
          let(:mobilisation_period) { 5 }
          let(:extension_details) do
            [
              { extension: 0, years: 6, months: 7, extension_required: 'true' },
              { extension: 1, years: nil, months: nil, extension_required: 'false' },
              { extension: 2, years: nil, months: nil, extension_required: 'false' },
              { extension: 3, years: nil, months: nil, extension_required: 'false' }
            ]
          end

          it 'is not valid' do
            expect(procurement.valid?(:contract_period)).to be false
          end

          it 'has the correct error message' do
            procurement.valid?(:contract_period)
            expect(procurement.errors[:base].first).to eq 'Call-off contract period, including extensions and mobilisation period, must not be more than 10 years in total'
          end
        end

        context 'and there are 3 extension period' do
          let(:mobilisation_period) { 9 }
          let(:extension_details) do
            [
              { extension: 0, years: 2, months: 6, extension_required: 'true' },
              { extension: 1, years: 2, months: 6, extension_required: 'true' },
              { extension: 2, years: 1, months: 6, extension_required: 'true' },
              { extension: 3, years: nil, months: nil, extension_required: 'false' }
            ]
          end

          it 'is not valid' do
            expect(procurement.valid?(:contract_period)).to be false
          end

          it 'has the correct error message' do
            procurement.valid?(:contract_period)
            expect(procurement.errors[:base].first).to eq 'Call-off contract period, including extensions and mobilisation period, must not be more than 10 years in total'
          end
        end
      end

      context 'and the total is just less than 10 years' do
        context 'and there is 1 extension period' do
          let(:mobilisation_period) { 4 }
          let(:extension_details) do
            [
              { extension: 0, years: 6, months: 7, extension_required: 'true' },
              { extension: 1, years: nil, months: nil, extension_required: 'false' },
              { extension: 2, years: nil, months: nil, extension_required: 'false' },
              { extension: 3, years: nil, months: nil, extension_required: 'false' }
            ]
          end

          it 'is valid' do
            expect(procurement.valid?(:contract_period)).to be true
          end
        end

        context 'and there are 3 extension period' do
          let(:mobilisation_period) { 8 }
          let(:extension_details) do
            [
              { extension: 0, years: 2, months: 6, extension_required: 'true' },
              { extension: 1, years: 2, months: 6, extension_required: 'true' },
              { extension: 2, years: 1, months: 6, extension_required: 'true' },
              { extension: 3, years: 1, months: 1, extension_required: 'false' }
            ]
          end

          it 'is valid' do
            expect(procurement.valid?(:contract_period)).to be true
          end
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups

  describe 'saving extension periods' do
    before do
      procurement.initial_call_off_period_years = 3
      procurement.initial_call_off_period_months = 4
      procurement.mobilisation_period_required = false

      procurement.extensions_required = true
      procurement.assign_attributes(call_off_extensions_attributes: extension_details)
    end

    context 'when the extensions are not valid' do
      let(:extension_details) do
        [
          { extension: 0, years: 1, months: 0, extension_required: 'true' },
          { extension: 1, years: 1, months: 1, extension_required: 'true' },
          { extension: 2, years: 1, months: 13, extension_required: 'true' },
          { extension: 3, years: 0, months: 1, extension_required: 'true' }
        ]
      end

      it 'is not valid' do
        expect(procurement.save(context: :contract_period)).to be false
      end

      it 'has the correct error message' do
        procurement.save(context: :contract_period)
        expect(procurement.errors[:'call_off_extensions.months'].first).to eq 'The months for the extension period must be between 0 and 11'
      end
    end

    context 'when the extensions are valid' do
      context 'and there is 1 extension' do
        let(:extension_details) do
          [
            { extension: 0, years: 1, months: 1, extension_required: 'true' },
            { extension: 1, years: 1, months: 1, extension_required: 'false' },
            { extension: 2, years: 1, months: 1, extension_required: 'false' },
            { extension: 3, years: 1, months: 1, extension_required: 'false' }
          ]
        end

        it 'is valid' do
          expect(procurement.save(context: :contract_period)).to be true
        end

        it 'only saves the one extension' do
          procurement.save(context: :contract_period)
          procurement.reload

          expect(procurement.call_off_extensions.count).to eq 1
        end
      end

      context 'and there are 2 extensions' do
        let(:extension_details) do
          [
            { extension: 0, years: 1, months: 1, extension_required: 'true' },
            { extension: 1, years: 1, months: 1, extension_required: 'true' },
            { extension: 2, years: 1, months: 1, extension_required: 'false' },
            { extension: 3, years: 1, months: 1, extension_required: 'false' }
          ]
        end

        it 'is valid' do
          expect(procurement.save(context: :contract_period)).to be true
        end

        it 'only saves two extensions' do
          procurement.save(context: :contract_period)
          procurement.reload

          expect(procurement.call_off_extensions.count).to eq 2
        end
      end

      context 'and there are 3 extensions' do
        let(:extension_details) do
          [
            { extension: 0, years: 1, months: 1, extension_required: 'true' },
            { extension: 1, years: 1, months: 1, extension_required: 'true' },
            { extension: 2, years: 1, months: 1, extension_required: 'true' },
            { extension: 3, years: 1, months: 1, extension_required: 'false' }
          ]
        end

        it 'is valid' do
          expect(procurement.save(context: :contract_period)).to be true
        end

        it 'only saves three extensions' do
          procurement.save(context: :contract_period)
          procurement.reload

          expect(procurement.call_off_extensions.count).to eq 3
        end
      end

      context 'and there are 4 extensions' do
        let(:extension_details) do
          [
            { extension: 0, years: 1, months: 1, extension_required: 'true' },
            { extension: 1, years: 1, months: 1, extension_required: 'true' },
            { extension: 2, years: 1, months: 1, extension_required: 'true' },
            { extension: 3, years: 1, months: 1, extension_required: 'true' }
          ]
        end

        it 'is valid' do
          expect(procurement.save(context: :contract_period)).to be true
        end

        it 'saves all four extensions' do
          procurement.save(context: :contract_period)
          procurement.reload

          expect(procurement.call_off_extensions.count).to eq 4
        end
      end
    end
  end
end
