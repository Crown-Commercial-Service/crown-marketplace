require 'rails_helper'
require 'fm_calculator/calculator'

# rubocop:disable all

RSpec.describe FMCalculator::Calculator do
  subject(:calculator) do
  end

  before do
    @rates = CCS::FM::Rate.read_benchmark_rates
  end

  describe 'FM CalcFMulator'
  it 'FMCalcFMulator for sum' do
    rates = @rates
    X1 = FMCalculator::Calculator.new(rates, 3, 'G1', 23000, 125, 'Y', 'Y', 'Y', 'N').sumunitofmeasure
    expect(X1.round(0)).to eq(1376629)

    X2 = FMCalculator::Calculator.new(rates, 3, 'C5', 54, 0, 'Y', 'Y', 'Y', 'N').sumunitofmeasure
    expect(X2.round(0)).to eq(55712)

    X3 = FMCalculator::Calculator.new(rates, 3, 'C19', 0, 0, 'Y', 'Y', 'Y', 'N').sumunitofmeasure
    expect(X3.round(0)).to eq(0)

    X4 = FMCalculator::Calculator.new(rates, 3, 'E4', 450, 0, 'N', 'N', 'M', 'Y').sumunitofmeasure
    expect(X4.round(0)).to eq(1376)

    X5 = FMCalculator::Calculator.new(rates, 3, 'K1', 75, 0, 'N', 'N', 'N', 'Y').sumunitofmeasure
    expect(X5.round(0)).to eq(27055)

    X6 = FMCalculator::Calculator.new(rates, 3, 'H4', 2350, 0, 'N', 'N', 'N', 'Y').sumunitofmeasure
    expect(X6.round(0)).to eq(178515)

    X7 = FMCalculator::Calculator.new(rates, 3, 'G5', 56757, 0, 'N', 'N', 'N', 'N').sumunitofmeasure
    expect(X7.round(0)).to eq(550777)

    X8 = FMCalculator::Calculator.new(rates, 3, 'K2', 125, 0, 'N', 'N', 'N', 'N').sumunitofmeasure
    expect(X8.round(0)).to eq(104157)

    X9 = FMCalculator::Calculator.new(rates, 3, 'K7', 680, 0, 'N', 'N', 'N', 'N').sumunitofmeasure
    expect(X9.round(0)).to eq(59203)

    Y1 = FMCalculator::Calculator.new(rates, 3, 'G1', 23000, 125, 'Y', 'Y', 'Y', 'N').benchmarkedcostssum
    expect(Y1.round(0)).to eq(600241)

    Y2 = FMCalculator::Calculator.new(rates, 3, 'C5', 54, 0, 'Y', 'Y', 'Y', 'N').benchmarkedcostssum
    expect(Y2.round(0)).to eq(55712)

    Y3 = FMCalculator::Calculator.new(rates, 3, 'C19', 0, 0, 'Y', 'Y', 'Y', 'N').benchmarkedcostssum
    expect(Y3.round(0)).to eq(0)

    Y4 = FMCalculator::Calculator.new(rates, 3, 'E4', 450, 0, 'N', 'N', 'M', 'Y').benchmarkedcostssum
    expect(Y4.round(0)).to eq(1376)

    Y5 = FMCalculator::Calculator.new(rates, 3, 'K1', 75, 0, 'N', 'N', 'N', 'Y').benchmarkedcostssum
    expect(Y5.round(0)).to eq(27055)

    Y6 = FMCalculator::Calculator.new(rates, 3, 'H4', 2350, 0, 'N', 'N', 'N', 'Y').benchmarkedcostssum
    expect(Y6.round(0)).to eq(178515)

    Y7 = FMCalculator::Calculator.new(rates, 3, 'G5', 56757, 0, 'N', 'N', 'N', 'N').benchmarkedcostssum
    expect(Y7.round(0)).to eq(550777)

    Y8 = FMCalculator::Calculator.new(rates, 3, 'K2', 125, 0, 'N', 'N', 'N', 'N').benchmarkedcostssum
    expect(Y8.round(0)).to eq(104157)

    Y9 = FMCalculator::Calculator.new(rates, 3, 'K7', 680, 0, 'N', 'N', 'N', 'N').benchmarkedcostssum
    expect(Y9.round(0)).to eq(59203)

    SumX = X1 + X2 + X3 + X4 + X5 + X6 + X7 + X8 + X9
    expect(SumX.round(0)).to eq(2353424)

    SumY = Y1 + Y2 + Y3 + Y4 + Y5 + Y6 + Y7 + Y8 + Y9
    expect(SumY.round(0)).to eq(1577036)
  end
end
# rubocop:enable all
