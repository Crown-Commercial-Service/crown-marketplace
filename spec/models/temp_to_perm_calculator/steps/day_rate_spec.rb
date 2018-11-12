require 'rails_helper'

module TempToPermCalculator
  module Steps
    RSpec.describe DayRate, type: :model do
      subject(:step) do
        described_class.new(
          day_rate: 500
        )
      end

      describe '#next_step_class' do
        it 'is MarkupRate' do
          expect(step.next_step_class).to eq(MarkupRate)
        end
      end
    end
  end
end
