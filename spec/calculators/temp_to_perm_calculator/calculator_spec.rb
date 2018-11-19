require 'rails_helper'

module TempToPermCalculator
  RSpec.describe Calculator do
    let(:days_per_week) { 5 }
    let(:contract_start_date) { Date.parse('Monday, 5th November 2018') }
    let(:hire_date) { Date.parse('Monday, 12th November 2018') }
    let(:school_holidays) { 0 }

    let(:calculator) do
      described_class.new(
        day_rate: 100,
        days_per_week: days_per_week,
        contract_start_date: contract_start_date,
        hire_date: hire_date,
        markup_rate: 0.15,
        school_holidays: school_holidays
      )
    end
    let(:subject) { calculator }

    it { is_expected.to respond_to(:day_rate) }
    it { is_expected.to respond_to(:days_per_week) }
    it { is_expected.to respond_to(:contract_start_date) }
    it { is_expected.to respond_to(:hire_date) }
    it { is_expected.to respond_to(:markup_rate) }

    describe '#working_days' do
      it 'calculates the number of working days between start date and hire date' do
        expect(calculator.working_days).to eq(5)
      end

      context 'when the working period includes a bank holiday in England' do
        let(:august_bank_holiday) { Date.parse('Monday, 27th August 2018') }
        let(:contract_start_date) { august_bank_holiday }
        let(:hire_date) { Date.parse('Monday, 3rd September 2018') }

        it 'excludes the bank holiday in the calculation' do
          expect(calculator.working_days).to eq(4)
        end
      end

      context 'when the working period includes a school holiday' do
        let(:school_holidays) { 1 }

        it 'excludes the school holiday in the calculation' do
          expect(calculator.working_days).to eq(4)
        end
      end
    end

    describe '#daily_supplier_fee' do
      it 'calculates the daily supplier fee' do
        expect(calculator.daily_supplier_fee).to be_within(0.01).of(13.04)
      end
    end

    describe '#fee' do
      it 'calculates the total fee' do
        expect(calculator.fee).to be_within(1e-6).of(calculator.daily_supplier_fee * calculator.working_days)
      end

      context 'when the worker works two days per week' do
        let(:days_per_week) { 2 }

        it 'calculates a pro-rata total fee' do
          expected_fee = (calculator.daily_supplier_fee * calculator.working_days) * (days_per_week / 5.0)
          expect(calculator.fee).to be_within(1e-6).of(expected_fee)
        end
      end
    end
  end
end
