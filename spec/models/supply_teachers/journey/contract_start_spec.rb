require 'rails_helper'

RSpec.describe SupplyTeachers::Journey::ContractStart, type: :model do
  subject(:step) do
    described_class.new(
      contract_start_day: contract_start_day,
      contract_start_month: contract_start_month,
      contract_start_year: contract_start_year,
      hire_date_day: hire_date_day,
      hire_date_month: hire_date_month,
      hire_date_year: hire_date_year,
      days_per_week: days_per_week,
      day_rate: day_rate,
      markup_rate: markup_rate
    )
  end

  let(:contract_start_day) { 1 }
  let(:contract_start_month) { 1 }
  let(:contract_start_year) { 1970 }

  let(:hire_date_day) { 1 }
  let(:hire_date_month) { 1 }
  let(:hire_date_year) { 1970 }

  let(:days_per_week) { 5 }

  let(:day_rate) { 500 }

  let(:markup_rate) { 40 }

  it { is_expected.to be_valid }

  describe '#next_step_class' do
    it 'is Fee' do
      expect(step.next_step_class).to eq(SupplyTeachers::Journey::Fee)
    end
  end

  context 'with a missing contract_start_year' do
    let(:contract_start_year) { nil }

    it { is_expected.to be_invalid }
  end

  context 'with a missing contract_start_month' do
    let(:contract_start_month) { nil }

    it { is_expected.to be_invalid }
  end

  context 'with a missing contract_start_day' do
    let(:contract_start_day) { nil }

    it { is_expected.to be_invalid }
  end

  context 'with a non-numeric contract_start_year' do
    let(:contract_start_year) { 'abc' }

    it { is_expected.to be_invalid }
  end

  context 'with a non-numeric contract_start_month' do
    let(:contract_start_month) { 'abc' }

    it { is_expected.to be_invalid }
  end

  context 'with a non-numeric contract_start_day' do
    let(:contract_start_day) { 'abc' }

    it { is_expected.to be_invalid }
  end

  context 'with a nonsense contract_start_day' do
    let(:contract_start_day) { 123 }

    it { is_expected.to be_invalid }
  end

  context 'with a nonsense contract_start_month' do
    let(:contract_start_month) { 13 }

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

  context 'with a non-integer days_per_week' do
    let(:days_per_week) { '1.5' }

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
end
