require 'rails_helper'

module TempToPermCalculator
  module Steps
    RSpec.describe DaysPerWeek, type: :model do
      subject(:step) do
        described_class.new(
          days_per_week: 5
        )
      end

      describe '#next_step_class' do
        it 'is DayRate' do
          expect(step.next_step_class).to eq(DayRate)
        end
      end
    end
  end
end
