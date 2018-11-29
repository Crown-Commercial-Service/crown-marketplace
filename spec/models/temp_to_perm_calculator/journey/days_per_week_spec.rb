require 'rails_helper'

RSpec.describe TempToPermCalculator::Journey::DaysPerWeek, type: :model do
  subject(:step) do
    described_class.new(
      days_per_week: days_per_week
    )
  end

  let(:days_per_week) { 5 }

  it { is_expected.to be_valid }

  describe '#next_step_class' do
    it 'is DayRate' do
      expect(step.next_step_class).to eq(TempToPermCalculator::Journey::DayRate)
    end
  end

  context 'with a missing days_per_week' do
    let(:days_per_week) { nil }

    it { is_expected.to be_invalid }
  end

  context 'with a non-numeric days_per_week' do
    let(:days_per_week) { 'abc' }

    it { is_expected.to be_invalid }
  end
end
