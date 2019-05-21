require 'rails_helper'
require 'fm_calculator/calculator'

# rubocop:disable all

RSpec.describe FMCalculator::Calculator do
  subject(:calculator) do
  end

  describe 'FM CalcFMulator'
  it 'FMCalcFMulator for sum' do
    X1 = FMCalculator::Calculator.new(3, 'G1', 23000, 125, 'Y', 'Y', 'Y', 'N').sumunitofmeasure
    expect(X1).to eq(1376631)

    X2 = FMCalculator::Calculator.new(3, 'C5', 54, 0, 'Y', 'Y', 'Y', 'N').sumunitofmeasure
    expect(X2).to eq(55714)

    X3 = FMCalculator::Calculator.new(3, 'C19', 0, 0, 'Y', 'Y', 'Y', 'N').sumunitofmeasure
    expect(X3).to eq(0)

    X4 = FMCalculator::Calculator.new(3, 'E4', 450, 0, 'N', 'N', 'M', 'Y').sumunitofmeasure
    expect(X4).to eq(1379)

    X5 = FMCalculator::Calculator.new(3, 'K1', 75, 0, 'N', 'N', 'N', 'Y').sumunitofmeasure
    expect(X5).to eq(27054)

    X6 = FMCalculator::Calculator.new(3, 'H4', 2350, 0, 'N', 'N', 'N', 'Y').sumunitofmeasure
    expect(X6).to eq(178518)

    X7 = FMCalculator::Calculator.new(3, 'G5', 56757, 0, 'N', 'N', 'N', 'N').sumunitofmeasure
    expect(X7).to eq(550776)

    X8 = FMCalculator::Calculator.new(3, 'K2', 125, 0, 'N', 'N', 'N', 'N').sumunitofmeasure
    expect(X8).to eq(104156)

    X9 = FMCalculator::Calculator.new(3, 'K7', 680, 0, 'N', 'N', 'N', 'N').sumunitofmeasure
    expect(X9).to eq(59203)

    Y1 = FMCalculator::Calculator.new(3, 'G1', 23000, 125, 'Y', 'Y', 'Y', 'N').benchmarkedcostssum
    expect(Y1).to eq(600243)

    Y2 = FMCalculator::Calculator.new(3, 'C5', 54, 0, 'Y', 'Y', 'Y', 'N').benchmarkedcostssum
    expect(Y2).to eq(55714)

    Y3 = FMCalculator::Calculator.new(3, 'C19', 0, 0, 'Y', 'Y', 'Y', 'N').benchmarkedcostssum
    expect(Y3).to eq(0)

    Y4 = FMCalculator::Calculator.new(3, 'E4', 450, 0, 'N', 'N', 'M', 'Y').benchmarkedcostssum
    expect(Y4).to eq(1379)

    Y5 = FMCalculator::Calculator.new(3, 'K1', 75, 0, 'N', 'N', 'N', 'Y').benchmarkedcostssum
    expect(Y5).to eq(27054)

    Y6 = FMCalculator::Calculator.new(3, 'H4', 2350, 0, 'N', 'N', 'N', 'Y').benchmarkedcostssum
    expect(Y6).to eq(178518)

    Y7 = FMCalculator::Calculator.new(3, 'G5', 56757, 0, 'N', 'N', 'N', 'N').benchmarkedcostssum
    expect(Y7).to eq(550776)

    Y8 = FMCalculator::Calculator.new(3, 'K2', 125, 0, 'N', 'N', 'N', 'N').benchmarkedcostssum
    expect(Y8).to eq(104156)

    Y9 = FMCalculator::Calculator.new(3, 'K7', 680, 0, 'N', 'N', 'N', 'N').benchmarkedcostssum
    expect(Y9).to eq(59203)

    SumX = X1 + X2 + X3 + X4 + X5 + X6 + X7 + X8 + X9
    expect(SumX).to eq(2353431)

    SumY = Y1 + Y2 + Y3 + Y4 + Y5 + Y6 + Y7 + Y8 + Y9
    expect(SumY).to eq(1577043)
  end
end
# rubocop:enable all
