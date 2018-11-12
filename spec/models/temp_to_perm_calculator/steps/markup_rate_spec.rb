require 'rails_helper'

module TempToPermCalculator
  module Steps
    RSpec.describe MarkupRate, type: :model do
      subject(:step) do
        described_class.new(
          markup_rate: 40
        )
      end

      describe '#next_step_class' do
        it 'is SchoolHolidays' do
          expect(step.next_step_class).to eq(SchoolHolidays)
        end
      end
    end
  end
end
