require 'rails_helper'
require 'fm_calculator/calculator'

# rubocop:disable all

RSpec.describe FMCalculator::Calculator do
  subject(:calculator) do
  end

  before do
    @rates = CCS::FM::Rate.read_benchmark_rates
  end

  describe 'FM CalcFMulator' do
    it 'FMCalcFMulator for sum' do
      rates = @rates
      X1 = FMCalculator::Calculator.new(3, 'G1', 23000, 125, 'Y', 'Y', 'Y', 'N', rates).sumunitofmeasure
      expect(X1.round(0)).to eq(1341251)

      X2 = FMCalculator::Calculator.new(3, 'C5', 54, 0, 'Y', 'Y', 'Y', 'N', rates).sumunitofmeasure
      expect(X2.round(0)).to eq(54280)

      X3 = FMCalculator::Calculator.new(3, 'C19', 0, 0, 'Y', 'Y', 'Y', 'N', rates).sumunitofmeasure
      expect(X3.round(0)).to eq(0)

      X4 = FMCalculator::Calculator.new(3, 'E4', 450, 0, 'N', 'N', 'M', 'Y', rates).sumunitofmeasure
      expect(X4.round(0)).to eq(1477)

      X5 = FMCalculator::Calculator.new(3, 'K1', 75, 0, 'N', 'N', 'N', 'Y', rates).sumunitofmeasure
      expect(X5.round(0)).to eq(29040)

      X6 = FMCalculator::Calculator.new(3, 'H4', 2350, 0, 'N', 'N', 'N', 'Y', rates).sumunitofmeasure
      expect(X6.round(0)).to eq(191609)

      X7 = FMCalculator::Calculator.new(3, 'G5', 56757, 0, 'N', 'N', 'N', 'N', rates).sumunitofmeasure
      expect(X7.round(0)).to eq(591178)

      X8 = FMCalculator::Calculator.new(3, 'K2', 125, 0, 'N', 'N', 'N', 'N', rates).sumunitofmeasure
      expect(X8.round(0)).to eq(111797)

      X9 = FMCalculator::Calculator.new(3, 'K7', 680, 0, 'N', 'N', 'N', 'N', rates).sumunitofmeasure
      expect(X9.round(0)).to eq(63546)

      Y1 = FMCalculator::Calculator.new(3, 'G1', 23000, 125, 'Y', 'Y', 'Y', 'N', rates).benchmarkedcostssum
      expect(Y1.round(0)).to eq(584815)

      Y2 = FMCalculator::Calculator.new(3, 'C5', 54, 0, 'Y', 'Y', 'Y', 'N', rates).benchmarkedcostssum
      expect(Y2.round(0)).to eq(54280)

      Y3 = FMCalculator::Calculator.new(3, 'C19', 0, 0, 'Y', 'Y', 'Y', 'N', rates).benchmarkedcostssum
      expect(Y3.round(0)).to eq(0)

      Y4 = FMCalculator::Calculator.new(3, 'E4', 450, 0, 'N', 'N', 'M', 'Y', rates).benchmarkedcostssum
      expect(Y4.round(0)).to eq(1340)

      Y5 = FMCalculator::Calculator.new(3, 'K1', 75, 0, 'N', 'N', 'N', 'Y', rates).benchmarkedcostssum
      expect(Y5.round(0)).to eq(26360)

      Y6 = FMCalculator::Calculator.new(3, 'H4', 2350, 0, 'N', 'N', 'N', 'Y', rates).benchmarkedcostssum
      expect(Y6.round(0)).to eq(173929)

      Y7 = FMCalculator::Calculator.new(3, 'G5', 56757, 0, 'N', 'N', 'N', 'N', rates).benchmarkedcostssum
      expect(Y7.round(0)).to eq(536629)

      Y8 = FMCalculator::Calculator.new(3, 'K2', 125, 0, 'N', 'N', 'N', 'N', rates).benchmarkedcostssum
      expect(Y8.round(0)).to eq(101481)

      Y9 = FMCalculator::Calculator.new(3, 'K7', 680, 0, 'N', 'N', 'N', 'N', rates).benchmarkedcostssum
      expect(Y9.round(0)).to eq(57682)

      SumX = X1 + X2 + X3 + X4 + X5 + X6 + X7 + X8 + X9
      expect(SumX.round(0)).to eq(2384177)

      SumY = Y1 + Y2 + Y3 + Y4 + Y5 + Y6 + Y7 + Y8 + Y9
      expect(SumY.round(0)).to eq(1536518)
    end
  end
end
# rubocop:enable all
