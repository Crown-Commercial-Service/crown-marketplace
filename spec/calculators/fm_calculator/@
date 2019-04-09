require 'rails_helper'
require 'fm_calculator/calculator'

# rubocop:disable all

RSpec.describe FMCalculator::Calculator do
  subject(:calculator) do
  end

  before(:all) do
    # args  Service ref, uom_vol, occupants, tuoe involved, london_location, CAFM, helpdesk
    CalcFM = described_class.new('G1', 23000, 125, 'Y', 'Y', ' Y', 'N')
  end

  describe 'FM CalcFMulator'
  it 'FMCalcFMulator for sum' do
    X1 = CalcFM.sumunitofmeasure('G1', 23000, 125, 'Y', 'Y', 'Y', 'N')
    expect(X1).to eq(899962)

    X2 = CalcFM.sumunitofmeasure('C5', 54, 0, 'Y', 'Y', 'Y', 'N')
    expect(X2).to eq(36423)

    X3 = CalcFM.sumunitofmeasure('C19', 0, 0, 'Y', 'Y', 'Y', 'N')
    expect(X3).to eq(0)

    X4 = CalcFM.sumunitofmeasure('E4', 450, 0, 'N', 'N', 'M', 'Y')
    expect(X4).to eq(900)

    X5 = CalcFM.sumunitofmeasure('K1', 75, 0, 'N', 'N', 'N', 'Y')
    expect(X5).to eq(17651)

    X6 = CalcFM.sumunitofmeasure('H4', 2350, 0, 'N', 'N', 'N', 'Y')
    expect(X6).to eq(116470)

    X7 = CalcFM.sumunitofmeasure('G5', 56757, 0, 'N', 'N', 'N', 'N')
    expect(X7).to eq(359342)

    X8 = CalcFM.sumunitofmeasure('K2', 125, 0, 'N', 'N', 'N', 'N')
    expect(X8).to eq(67954)

    X9 = CalcFM.sumunitofmeasure('K7', 680, 0, 'N', 'N', 'N', 'N')
    expect(X9).to eq(38626)

    Y1 = CalcFM.benchmarkedcostssum('G1', 23000, 125, 'Y', 'Y', 'Y', 'N')
    expect(Y1).to eq(392404)

    Y2 = CalcFM.benchmarkedcostssum('C5', 54, 0, 'Y', 'Y', 'Y', 'N')
    expect(Y2).to eq(36423)

    Y3 = CalcFM.benchmarkedcostssum('C19', 0, 0, 'Y', 'Y', 'Y', 'N')
    expect(Y3).to eq(0)

    Y4 = CalcFM.benchmarkedcostssum('E4', 450, 0, 'N', 'N', 'M', 'Y')
    expect(Y4).to eq(900)
    Y5 = CalcFM.benchmarkedcostssum('K1', 75, 0, 'N', 'N', 'N', 'Y')
    expect(Y5).to eq(17651)

    Y6 = CalcFM.benchmarkedcostssum('H4', 2350, 0, 'N', 'N', 'N', 'Y')
    expect(Y6).to eq(116470)
    Y7 = CalcFM.benchmarkedcostssum('G5', 56757, 0, 'N', 'N', 'N', 'N')
    expect(Y7).to eq(359342)

    Y8 = CalcFM.benchmarkedcostssum('K2', 125, 0, 'N', 'N', 'N', 'N')
    expect(Y8).to eq(67954)

    Y9 = CalcFM.benchmarkedcostssum('K7', 680, 0, 'N', 'N', 'N', 'N')
    expect(Y9).to eq(38626)

    SumX = X1 + X2 + X3 + X4 + X5 + X6 + X7 + X8 + X9
    expect(SumX).to eq(1537328)

    SumY = Y1 + Y2 + Y3 + Y4 + Y5 + Y6 + Y7 + Y8 + Y9
    expect(SumY).to eq(1029770)
  end
end
# rubocop:enable all
