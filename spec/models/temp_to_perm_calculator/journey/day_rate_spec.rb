require 'rails_helper'

RSpec.describe TempToPermCalculator::Journey::DayRate, type: :model do
  subject(:step) do
    described_class.new(
      day_rate: day_rate
    )
  end

  let(:day_rate) { 500 }

  it { is_expected.to be_valid }

  describe '#next_step_class' do
    it 'is MarkupRate' do
      expect(step.next_step_class).to eq(TempToPermCalculator::Journey::MarkupRate)
    end
  end

  context 'with a missing day_rate' do
    let(:day_rate) { nil }

    it { is_expected.to be_invalid }
  end

  context 'with a non-numeric day_rate' do
    let(:day_rate) { 'abc' }

    it { is_expected.to be_invalid }
  end
end
