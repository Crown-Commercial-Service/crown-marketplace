require 'rails_helper'

module TempToPermCalculator
  module Steps
    RSpec.describe ContractStart, type: :model do
      subject(:step) do
        described_class.new(
          contract_start_day: 1,
          contract_start_month: 1,
          contract_start_year: 1970
        )
      end

      describe '#next_step_class' do
        it 'is HireDate' do
          expect(step.next_step_class).to eq(HireDate)
        end
      end
    end
  end
end
