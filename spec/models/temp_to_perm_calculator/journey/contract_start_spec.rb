require 'rails_helper'

RSpec.describe TempToPermCalculator::Journey::ContractStart, type: :model do
  subject(:step) do
    described_class.new(
      contract_start_day: contract_start_day,
      contract_start_month: contract_start_month,
      contract_start_year: contract_start_year
    )
  end

  let(:contract_start_day) { 1 }
  let(:contract_start_month) { 1 }
  let(:contract_start_year) { 1970 }

  it { is_expected.to be_valid }

  describe '#next_step_class' do
    it 'is HireDate' do
      expect(step.next_step_class).to eq(TempToPermCalculator::Journey::HireDate)
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
end
