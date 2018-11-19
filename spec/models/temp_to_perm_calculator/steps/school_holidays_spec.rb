require 'rails_helper'

RSpec.describe TempToPermCalculator::Steps::SchoolHolidays, type: :model do
  subject(:step) do
    described_class.new(
      school_holidays: 1
    )
  end

  it { is_expected.to be_valid }

  describe '#next_step_class' do
    it 'is Fee' do
      expect(step.next_step_class).to eq(TempToPermCalculator::Steps::Fee)
    end
  end
end
