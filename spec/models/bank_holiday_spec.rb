require 'rails_helper'

RSpec.describe BankHoliday do
  describe '.bank_holiday?' do
    let(:result) { described_class.bank_holiday?(date) }

    context 'when the date is a bank holiday' do
      let(:date) { Date.new(2026, 12, 25) }

      it 'returns true' do
        expect(result).to be(true)
      end
    end

    context 'when the date is not a bank holiday' do
      let(:date) { Date.new(2026, 12, 24) }

      it 'returns false' do
        expect(result).to be(false)
      end
    end
  end
end
