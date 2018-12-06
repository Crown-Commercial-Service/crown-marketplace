require 'rails_helper'

RSpec.describe TempToPermCalculator::Calculator do
  let(:days_per_week) { 5 }
  let(:contract_start_date) { Date.parse('Monday, 5th November 2018') }
  let(:hire_date) { Date.parse('Monday, 12th November 2018') }

  let(:calculator) do
    described_class.new(
      day_rate: 100,
      days_per_week: days_per_week,
      contract_start_date: contract_start_date,
      hire_date: hire_date,
      markup_rate: 0.15
    )
  end
  let(:subject) { calculator }

  it { is_expected.to respond_to(:day_rate) }
  it { is_expected.to respond_to(:days_per_week) }
  it { is_expected.to respond_to(:contract_start_date) }
  it { is_expected.to respond_to(:hire_date) }
  it { is_expected.to respond_to(:markup_rate) }

  describe '#working_days' do
    it 'calculates the number of working days between start date and hire date' do
      expect(calculator.working_days).to eq(5)
    end

    context 'when the working period includes a bank holiday in England' do
      let(:august_bank_holiday) { Date.parse('Monday, 27th August 2018') }
      let(:contract_start_date) { august_bank_holiday }
      let(:hire_date) { Date.parse('Monday, 3rd September 2018') }

      it 'excludes the bank holiday in the calculation' do
        expect(calculator.working_days).to eq(4)
      end
    end
  end

  describe '#daily_supplier_fee' do
    it 'calculates the daily supplier fee' do
      expect(calculator.daily_supplier_fee).to be_within(0.01).of(13.04)
    end
  end

  describe '#early_hire_fee' do
    context 'when the school hires the worker within the first 40 days of the contract' do
      let(:calculator) do
        described_class.new(
          day_rate: 200,
          days_per_week: 5,
          contract_start_date: Date.parse('Mon 4 Feb, 2019'),
          hire_date: Date.parse('Mon 11 Feb, 2019'),
          markup_rate: 0.16
        )
      end

      it 'calculates the fee as the number of chargeable working days between hire date and 60 working days from start of contract' do
        working_days_between_contract_start_and_hire_date = 5
        chargeable_working_days_based_on_early_hire = 60 - working_days_between_contract_start_and_hire_date
        supplier_rate_per_day = 200 - (200 / (1 + 0.16))
        expected_fee = chargeable_working_days_based_on_early_hire * supplier_rate_per_day

        expect(calculator.early_hire_fee).to be_within(1e-6).of(expected_fee)
      end
    end

    context 'when the school hires the worker on the 61st working day from the start of the contract' do
      let(:calculator) do
        described_class.new(
          day_rate: 200,
          days_per_week: 5,
          contract_start_date: Date.parse('Mon 7 Jan, 2019'),
          hire_date: Date.parse('Mon 1 Apr, 2019'),
          markup_rate: 0.16
        )
      end

      it 'calculates the early hire fee as 0' do
        expect(calculator.early_hire_fee).to eq(0)
      end
    end

    context 'when the school hires the worker after 60 working days from the start of the contract' do
      let(:calculator) do
        described_class.new(
          day_rate: 200,
          days_per_week: 5,
          contract_start_date: Date.parse('Mon 7 Jan, 2019'),
          hire_date: Date.parse('Mon 29 Apr, 2019'),
          markup_rate: 0.16
        )
      end

      it 'calculates the early hire fee as 0' do
        expect(calculator.early_hire_fee).to eq(0)
      end
    end
  end

  describe '#fee_for_early_hire?' do
    let(:calculator) do
      described_class.new(
        day_rate: 200,
        days_per_week: 5,
        contract_start_date: Date.parse('Mon 7 Jan, 2019'),
        hire_date: hire_date,
        markup_rate: 0.16
      )
    end

    context 'when the school hires the worker within the first 60 working days of the contract' do
      let(:hire_date) { Date.parse('Thu 28 Mar, 2019') }

      it 'is false' do
        expect(calculator.fee_for_early_hire?).to be true
      end
    end

    context 'when the school hires the worker on the 60th working day of the contract' do
      let(:hire_date) { Date.parse('Fri 29 Mar, 2019') }

      it 'is true' do
        expect(calculator.fee_for_early_hire?).to be true
      end
    end

    context 'when the school hires the worker on the 61st working day of the contract' do
      let(:hire_date) { Date.parse('Mon 1 Apr, 2019') }

      it 'is true' do
        expect(calculator.fee_for_early_hire?).to be false
      end
    end

    context 'when the school hires the worker after the 61st working day of the contract' do
      let(:hire_date) { Date.parse('Tue 2 Apr, 2019') }

      it 'is true' do
        expect(calculator.fee_for_early_hire?).to be false
      end
    end
  end

  describe '#fee_for_lack_of_notice?' do
    let(:calculator) do
      described_class.new(
        day_rate: 200,
        days_per_week: 5,
        contract_start_date: Date.parse('Mon 7 Jan, 2019'),
        hire_date: hire_date,
        markup_rate: 0.16
      )
    end

    context 'when the school hires the worker within the first 40 working days of the contract' do
      let(:hire_date) { Date.parse('Tue 8 Jan, 2019') }

      it 'is false' do
        expect(calculator.fee_for_lack_of_notice?).to be false
      end
    end

    context 'when the school hires the worker on the 40th working day of the contract' do
      let(:hire_date) { Date.parse('Fri 1 Mar, 2019') }

      it 'is true' do
        expect(calculator.fee_for_lack_of_notice?).to be false
      end
    end

    context 'when the school hires the worker on the 41st working day of the contract' do
      let(:hire_date) { Date.parse('Mon 4 Mar, 2019') }

      it 'is true' do
        expect(calculator.fee_for_lack_of_notice?).to be true
      end
    end

    context 'when the school hires the worker after the 41st working day of the contract' do
      let(:hire_date) { Date.parse('Mon 29 Mar, 2019') }

      it 'is true' do
        expect(calculator.fee_for_lack_of_notice?).to be true
      end
    end
  end

  describe '#ideal_hire_date' do
    let(:calculator) do
      described_class.new(
        day_rate: 200,
        days_per_week: 5,
        contract_start_date: Date.parse('Mon 7 Jan, 2019'),
        hire_date: Date.parse('Tue 8 Jan, 2019'),
        markup_rate: 0.16
      )
    end

    it 'is 61 working days from the contract start date to avoid paying early hire fee' do
      expect(calculator.ideal_hire_date).to eq(Date.parse('Mon 1 Apr, 2019'))
    end
  end

  describe '#ideal_notice_date' do
    let(:calculator) do
      described_class.new(
        day_rate: 200,
        days_per_week: 5,
        contract_start_date: Date.parse('Mon 7 Jan, 2019'),
        hire_date: Date.parse('Tue 8 Jan, 2019'),
        markup_rate: 0.16
      )
    end

    it 'is 41 working days from the contract start date to avoid paying lack of notice fee' do
      expect(calculator.ideal_notice_date).to eq(Date.parse('Mon 4 Mar, 2019'))
    end
  end

  describe '#before_national_deal_began?' do
    let(:calculator) do
      described_class.new(
        day_rate: 200,
        days_per_week: 5,
        contract_start_date: contract_start_date,
        hire_date: Date.parse('Tue 8 Jan, 2019'),
        markup_rate: 0.16
      )
    end

    context 'when the contract start date is before 23 Aug 2018' do
      let(:contract_start_date) { Date.parse('22 Aug 2018') }

      it 'is true' do
        expect(calculator.before_national_deal_began?).to be true
      end
    end

    context 'when the contract start date is on or after 23 Aug 2018' do
      let(:contract_start_date) { Date.parse('23 Aug 2018') }

      it 'is false' do
        expect(calculator.before_national_deal_began?).to be false
      end
    end
  end

  describe '#notice_period_required?' do
    let(:calculator) do
      described_class.new(
        day_rate: 200,
        days_per_week: 5,
        contract_start_date: Date.parse('Mon 3 Sep 2018'),
        hire_date: hire_date,
        markup_rate: 0.16
      )
    end

    context 'when the hire date is less than 40 working days after the contract start date' do
      let(:hire_date) { Date.parse('Thu 25 Oct 2018') }

      it 'returns false' do
        expect(calculator.notice_period_required?).to eq(false)
      end
    end

    context 'when the hire date is 40 working days after the contract start date' do
      let(:hire_date) { Date.parse('Fri 26 Oct 2018') }

      it 'returns false' do
        expect(calculator.notice_period_required?).to eq(false)
      end
    end

    context 'when the hire date is more than 40 working days after the contract start date' do
      let(:hire_date) { Date.parse('Mon 29 Oct 2018') }

      it 'returns true' do
        expect(calculator.notice_period_required?).to eq(true)
      end
    end
  end

  describe '#notice_date_based_on_hire_date' do
    let(:calculator) do
      described_class.new(
        day_rate: 200,
        days_per_week: 5,
        contract_start_date: Date.parse('Mon 3 Sep 2018'),
        hire_date: hire_date,
        markup_rate: 0.16
      )
    end

    context 'when the hire date is less than 40 working days after the contract start date' do
      let(:hire_date) { Date.parse('Thu 25 Oct 2018') }

      it 'returns nil' do
        expect(calculator.notice_date_based_on_hire_date).to be_nil
      end
    end

    context 'when the hire date is 40 working days after the contract start date' do
      let(:hire_date) { Date.parse('Fri 26 Oct 2018') }

      it 'returns nil' do
        expect(calculator.notice_date_based_on_hire_date).to be_nil
      end
    end

    context 'when the hire date is more than 40 working days after the contract start date' do
      let(:hire_date) { Date.parse('Mon 29 Oct 2018') }

      it 'returns 20 working days before the hire date' do
        expected_notice_date = Date.parse('Mon 1 Oct 2018')
        expect(calculator.notice_date_based_on_hire_date).to eq(expected_notice_date)
      end
    end
  end
end
