require 'rails_helper'

module TempToPermCalculator
  module Steps
    RSpec.describe SchoolHolidays, type: :model do
      subject(:step) do
        described_class.new(
          school_holidays: 1
        )
      end

      it { is_expected.to be_valid }

      describe '#next_step_class' do
        it 'is Fee' do
          expect(step.next_step_class).to eq(Fee)
        end
      end
    end
  end
end
