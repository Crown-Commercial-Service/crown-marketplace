require 'rails_helper'

RSpec.describe TempToPermCalculator::Journey::HireDate, type: :model do
  subject(:step) do
    described_class.new(
      hire_date_day: hire_date_day,
      hire_date_month: hire_date_month,
      hire_date_year: hire_date_year
    )
  end

  let(:hire_date_day) { 1 }
  let(:hire_date_month) { 1 }
  let(:hire_date_year) { 1970 }

  it { is_expected.to be_valid }

  describe '#next_step_class' do
    it 'is DaysPerWeek' do
      expect(step.next_step_class).to eq(TempToPermCalculator::Journey::DaysPerWeek)
    end
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
end
