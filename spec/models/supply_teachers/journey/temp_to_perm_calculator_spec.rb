require 'rails_helper'

RSpec.describe SupplyTeachers::Journey::TempToPermCalculator, type: :model do
  subject(:step) do
    described_class.new(
      contract_start_date_day: contract_start_date_day,
      contract_start_date_month: contract_start_date_month,
      contract_start_date_year: contract_start_date_year,
      hire_date_day: hire_date_day,
      hire_date_month: hire_date_month,
      hire_date_year: hire_date_year,
      days_per_week: days_per_week,
      day_rate: day_rate,
      markup_rate: markup_rate,
      notice_date_day: notice_date_day,
      notice_date_month: notice_date_month,
      notice_date_year: notice_date_year
    )
  end

  let(:model_key) { 'activemodel.errors.models.supply_teachers/journey/temp_to_perm_calculator' }

  let(:contract_start_date_day) { 1 }
  let(:contract_start_date_month) { 1 }
  let(:contract_start_date_year) { 1970 }

  let(:hire_date_day) { 2 }
  let(:hire_date_month) { 1 }
  let(:hire_date_year) { 1970 }

  let(:notice_date_day) { 3 }
  let(:notice_date_month) { 1 }
  let(:notice_date_year) { 1970 }

  let(:days_per_week) { 5 }

  let(:day_rate) { 500 }

  let(:markup_rate) { 40 }

  it { is_expected.to be_valid }

  describe '#next_step_class' do
    it 'is Fee' do
      expect(step.next_step_class).to eq(SupplyTeachers::Journey::TempToPermFee)
    end
  end

  describe '#contract_start_date' do
    it 'returns date instance constructed from day, month & year' do
      expect(step.contract_start_date).to eq(Date.parse('1970-01-01'))
    end

    context 'when day is missing' do
      let(:contract_start_date_day) { nil }

      it 'returns nil' do
        expect(step.contract_start_date).to be_nil
      end
    end

    context 'when month is missing' do
      let(:contract_start_date_month) { nil }

      it 'returns nil' do
        expect(step.contract_start_date).to be_nil
      end
    end

    context 'when day is missing' do
      let(:contract_start_date_year) { nil }

      it 'returns nil' do
        expect(step.contract_start_date).to be_nil
      end
    end
  end

  describe '#hire_date' do
    it 'returns date instance constructed from day, month & year' do
      expect(step.hire_date).to eq(Date.parse('1970-01-02'))
    end

    context 'when day is missing' do
      let(:hire_date_day) { nil }

      it 'returns nil' do
        expect(step.hire_date).to be_nil
      end
    end

    context 'when month is missing' do
      let(:hire_date_month) { nil }

      it 'returns nil' do
        expect(step.hire_date).to be_nil
      end
    end

    context 'when day is missing' do
      let(:hire_date_year) { nil }

      it 'returns nil' do
        expect(step.hire_date).to be_nil
      end
    end
  end

  describe '#notice_date' do
    it 'returns date instance constructed from day, month & year' do
      expect(step.notice_date).to eq(Date.parse('1970-01-03'))
    end

    context 'when day is missing' do
      let(:notice_date_day) { nil }

      it 'returns nil' do
        expect(step.notice_date).to be_nil
      end
    end

    context 'when month is missing' do
      let(:notice_date_month) { nil }

      it 'returns nil' do
        expect(step.notice_date).to be_nil
      end
    end

    context 'when year is missing' do
      let(:notice_date_year) { nil }

      it 'returns nil' do
        expect(step.notice_date).to be_nil
      end
    end
  end

  context 'with a missing contract_start_date_year' do
    let(:contract_start_date_year) { nil }

    it { is_expected.to be_invalid }
  end

  context 'with a missing contract_start_date_month' do
    let(:contract_start_date_month) { nil }

    it { is_expected.to be_invalid }
  end

  context 'with a missing contract_start_date_day' do
    let(:contract_start_date_day) { nil }

    it { is_expected.to be_invalid }
  end

  context 'with a non-numeric contract_start_date_year' do
    let(:contract_start_date_year) { 'abc' }

    it { is_expected.to be_invalid }
  end

  context 'with a non-numeric contract_start_date_month' do
    let(:contract_start_date_month) { 'abc' }

    it { is_expected.to be_invalid }
  end

  context 'with a non-numeric contract_start_date_day' do
    let(:contract_start_date_day) { 'abc' }

    it { is_expected.to be_invalid }
  end

  context 'with a nonsense contract_start_date_day' do
    let(:contract_start_date_day) { 123 }

    it { is_expected.to be_invalid }
  end

  context 'with a nonsense contract_start_date_month' do
    let(:contract_start_date_month) { 13 }

    it { is_expected.to be_invalid }
  end

  context 'with a missing hire_date_year' do
    let(:hire_date_year) { nil }

    it { is_expected.to be_invalid }
  end

  context 'with a missing hire_date_month' do
    let(:hire_date_month) { nil }

    it { is_expected.to be_invalid }
  end

  context 'with a missing hire_date_day' do
    let(:hire_date_day) { nil }

    it { is_expected.to be_invalid }
  end

  context 'with a non-numeric hire_date_year' do
    let(:hire_date_year) { 'abc' }

    it { is_expected.to be_invalid }
  end

  context 'with a non-numeric hire_date_month' do
    let(:hire_date_month) { 'abc' }

    it { is_expected.to be_invalid }
  end

  context 'with a non-numeric hire_date_day' do
    let(:hire_date_day) { 'abc' }

    it { is_expected.to be_invalid }
  end

  context 'with a nonsense hire_date_day' do
    let(:hire_date_day) { 123 }

    it { is_expected.to be_invalid }
  end

  context 'with a nonsense hire_date_month' do
    let(:hire_date_month) { 13 }

    it { is_expected.to be_invalid }
  end

  context 'with a missing days_per_week' do
    let(:days_per_week) { nil }

    it { is_expected.to be_invalid }
  end

  context 'with a non-numeric days_per_week' do
    let(:days_per_week) { 'abc' }

    it { is_expected.to be_invalid }
  end

  context 'with a negative days_per_week' do
    let(:days_per_week) { '-1' }

    it { is_expected.to be_invalid }
  end

  context 'with a zero days_per_week' do
    let(:days_per_week) { '0' }

    it { is_expected.to be_invalid }
  end

  context 'with a fractional days_per_week' do
    let(:days_per_week) { '0.5' }

    it { is_expected.to be_valid }
  end

  context 'with a days_per_week more than 5' do
    let(:days_per_week) { '6' }

    it { is_expected.to be_invalid }
  end

  context 'with a missing day_rate' do
    let(:day_rate) { nil }

    it { is_expected.to be_invalid }
  end

  context 'with a non-numeric day_rate' do
    let(:day_rate) { 'abc' }

    it { is_expected.to be_invalid }
  end

  context 'with a negative day_rate' do
    let(:day_rate) { '-100' }

    it { is_expected.to be_invalid }
  end

  context 'with a zero day_rate' do
    let(:day_rate) { '0' }

    it { is_expected.to be_invalid }
  end

  context 'with a non-integer day_rate' do
    let(:day_rate) { '123.50' }

    it { is_expected.to be_invalid }
  end

  context 'with a missing markup_rate' do
    let(:markup_rate) { nil }

    it { is_expected.to be_invalid }
  end

  context 'with a non-numeric markup_rate' do
    let(:markup_rate) { 'abc' }

    it { is_expected.to be_invalid }
  end

  context 'with a markup_rate greater than 100' do
    let(:markup_rate) { 110 }

    it { is_expected.to be_invalid }
  end

  context 'with a markup_rate less than 0' do
    let(:markup_rate) { -10 }

    it { is_expected.to be_invalid }
  end

  context 'with a hire_date on the contract_start_date' do
    let(:hire_date_day) { '10' }
    let(:hire_date_month) { '1' }
    let(:hire_date_year) { '2018' }

    let(:contract_start_date_day) { '10' }
    let(:contract_start_date_month) { '1' }
    let(:contract_start_date_year) { '2018' }

    it { is_expected.to be_invalid }

    it 'obtains the error message from an I18n translation' do
      step.valid?
      expect(step.errors[:hire_date]).to include(
        I18n.t("#{model_key}.attributes.hire_date.after_contract_start_date")
      )
    end

    context 'and hire_date is one day earlier' do
      let(:hire_date_day) { '9' }

      it { is_expected.to be_invalid }

      it 'obtains the error message from an I18n translation' do
        step.valid?
        expect(step.errors[:hire_date]).to include(
          I18n.t("#{model_key}.attributes.hire_date.after_contract_start_date")
        )
      end
    end

    context 'and hire_date is one day later' do
      let(:hire_date_day) { '11' }

      it { is_expected.to be_valid }
    end
  end
end
