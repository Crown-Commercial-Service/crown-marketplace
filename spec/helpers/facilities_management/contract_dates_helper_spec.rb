require 'rails_helper'

RSpec.describe FacilitiesManagement::ContractDatesHelper do
  include ApplicationHelper

  let(:procurement) { create(:facilities_management_rm3830_procurement, user: create(:user)) }

  before { @procurement = procurement }

  describe 'initial_call_off_period' do
    let(:initial_call_off_period_years) { 3 }
    let(:initial_call_off_period_months) { 3 }

    before do
      procurement.initial_call_off_period_years = initial_call_off_period_years
      procurement.initial_call_off_period_months = initial_call_off_period_months
    end

    context 'when months is 0' do
      let(:initial_call_off_period_months) { 0 }

      it 'returns 3 years' do
        expect(helper.initial_call_off_period).to eq '3 years'
      end
    end

    context 'when years is 0' do
      let(:initial_call_off_period_years) { 0 }

      it 'returns 3 months' do
        expect(helper.initial_call_off_period).to eq '3 months'
      end
    end

    context 'when both months and years are 1' do
      let(:initial_call_off_period_years) { 1 }
      let(:initial_call_off_period_months) { 1 }

      it 'returns 1 year and 1 month' do
        expect(helper.initial_call_off_period).to eq '1 year and 1 month'
      end
    end

    context 'when both months and years are 3' do
      let(:initial_call_off_period_years) { 3 }
      let(:initial_call_off_period_months) { 3 }

      it 'returns 3 years and 3 months' do
        expect(helper.initial_call_off_period).to eq '3 years and 3 months'
      end
    end
  end

  describe 'mobilisation_period' do
    let(:mobilisation_period_required) { true }
    let(:mobilisation_period) { 4 }

    before do
      procurement.mobilisation_period_required = mobilisation_period_required
      procurement.mobilisation_period = mobilisation_period
    end

    context 'when mobilisation period is not required' do
      let(:mobilisation_period_required) { false }

      it 'returns None' do
        expect(helper.mobilisation_period).to eq 'None'
      end
    end

    context 'when mobilisation period is 1' do
      let(:mobilisation_period) { 1 }

      it 'returns 1 week' do
        expect(helper.mobilisation_period).to eq '1 week'
      end
    end

    context 'when mobilisation period is 16' do
      let(:mobilisation_period) { 16 }

      it 'returns 16 weeks' do
        expect(helper.mobilisation_period).to eq '16 weeks'
      end
    end
  end

  describe 'call_off_extensions_period' do
    before do
      procurement.call_off_extensions.delete_all

      4.times do |extension|
        procurement.call_off_extensions.create(extension: extension, years: (extension + 1) % 4, months: extension * 2)
      end
    end

    context 'when considering time period' do
      it 'returns 1 year for the first extension period' do
        expect(helper.call_off_extensions_period(procurement.call_off_extension(0))).to eq '1 year'
      end

      it 'returns 2 years and 2 months for the second extension period' do
        expect(helper.call_off_extensions_period(procurement.call_off_extension(1))).to eq '2 years and 2 months'
      end

      it 'returns 3 years and 4 months for the third extension period' do
        expect(helper.call_off_extensions_period(procurement.call_off_extension(2))).to eq '3 years and 4 months'
      end

      it 'returns 6 months for the forth extension period' do
        expect(helper.call_off_extensions_period(procurement.call_off_extension(3))).to eq '6 months'
      end
    end
  end

  describe 'initial_call_off_period_description' do
    before do
      procurement.initial_call_off_start_date = initial_call_off_start_date
      procurement.initial_call_off_period_years = initial_call_off_period_years
      procurement.initial_call_off_period_months = initial_call_off_period_months
    end

    context 'when start date is 2022/12/07 and the period is 4 years and 6 months' do
      let(:initial_call_off_start_date) { Time.new(2022, 12, 7).in_time_zone('London') }
      let(:initial_call_off_period_years) { 3 }
      let(:initial_call_off_period_months) { 6 }

      it 'returns 7 December 2022 to 6 June 2026' do
        expect(helper.initial_call_off_period_description).to eq ' 7 December 2022 to  6 June 2026'
      end
    end

    context 'when start date is 2022/05/27 and the period is 6 years and 8 months' do
      let(:initial_call_off_start_date) { Time.new(2022, 5, 27).in_time_zone('London') }
      let(:initial_call_off_period_years) { 6 }
      let(:initial_call_off_period_months) { 8 }

      it 'returns 27 May 2022 to 26 January 2029' do
        expect(helper.initial_call_off_period_description).to eq '27 May 2022 to 26 January 2029'
      end
    end
  end

  describe 'mobilisation_period_description' do
    before do
      procurement.initial_call_off_start_date = initial_call_off_start_date
      procurement.mobilisation_period = mobilisation_period
      procurement.mobilisation_period_required = true
    end

    context 'when start date is 2022/11/05 and the mobilisation period is 2 weeks' do
      let(:initial_call_off_start_date) { Time.new(2022, 11, 5).in_time_zone('London') }
      let(:mobilisation_period) { 2 }

      it 'returns 21 October 2022 to 4 November 2022' do
        expect(helper.mobilisation_period_description).to eq '21 October 2022 to  4 November 2022'
      end
    end

    context 'when start date is 2024/06/05 and the mobilisation period is 40 weeks' do
      let(:initial_call_off_start_date) { Time.new(2024, 6, 5).in_time_zone('London') }
      let(:mobilisation_period) { 40 }

      it 'returns 29 August 2023 to 4 June 2024' do
        expect(helper.mobilisation_period_description).to eq '29 August 2023 to  4 June 2024'
      end
    end
  end

  describe 'extension_period_description' do
    before do
      procurement.initial_call_off_start_date = Time.new(2027, 2, 14).in_time_zone('London')
      procurement.initial_call_off_period_years = 3
      procurement.initial_call_off_period_months = 5
      procurement.extensions_required = true
      procurement.call_off_extensions.delete_all
      procurement.call_off_extensions.create(extension: 0, years: 1, months: 1)
      procurement.call_off_extensions.create(extension: 1, years: 0, months: 8)
      procurement.call_off_extensions.create(extension: 2, years: 1, months: 3)
      procurement.call_off_extensions.create(extension: 3, years: 2, months: 11)
    end

    context 'when considering the first extension period' do
      it 'returns 14 July 2030 to 13 August 2031' do
        expect(helper.extension_period_description(0)).to eq '14 July 2030 to 13 August 2031'
      end
    end

    context 'when considering the second extension period' do
      it 'returns 14 August 2031 to 13 April 2032' do
        expect(helper.extension_period_description(1)).to eq '14 August 2031 to 13 April 2032'
      end
    end

    context 'when considering the third extension period' do
      it 'returns 14 April 2032 to 13 July 2033' do
        expect(helper.extension_period_description(2)).to eq '14 April 2032 to 13 July 2033'
      end
    end

    context 'when considering the forth extension period' do
      it 'returns 14 July 2033 to 13 June 2036' do
        expect(helper.extension_period_description(3)).to eq '14 July 2033 to 13 June 2036'
      end
    end
  end

  describe '.date_of_first_indexation' do
    let(:result) { helper.date_of_first_indexation }

    before do
      procurement.initial_call_off_period_years = initial_call_off_period_years
      procurement.initial_call_off_period_months = 6
    end

    context 'when the contract length is less than a year' do
      let(:initial_call_off_period_years) { 0 }

      it "returns 'Not applicable'" do
        expect(result).to eq 'Not applicable'
      end
    end

    context 'when the contract length is more than a year' do
      let(:initial_call_off_period_years) { 1 }

      it 'returns one year after the icontract start date' do
        expect(result).to eq (6.months.from_now + 1.year).strftime '%e %B %Y'
      end
    end
  end
end
