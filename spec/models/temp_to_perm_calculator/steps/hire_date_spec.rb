require 'rails_helper'

module TempToPermCalculator
  module Steps
    RSpec.describe HireDate, type: :model do
      subject(:step) do
        described_class.new(
          hire_date_day: 1,
          hire_date_month: 1,
          hire_date_year: 1970
        )
      end

      describe '#next_step_class' do
        it 'is HireDate' do
          expect(step.next_step_class).to eq(DaysPerWeek)
        end
      end
    end
  end
end
