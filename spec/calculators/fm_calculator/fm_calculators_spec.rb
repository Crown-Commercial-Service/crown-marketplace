require 'csv'
require 'rails_helper'
require 'fm_calculator/calculator'

# rubocop:disable all

RSpec.describe FMCalculator::Calculator do
  subject(:calculator) do
  end

  let(:json_test_data) { JSON.parse(file_fixture('fm-calculator-test-data.json').read, symbolize_names: true) }
  let(:csv_test_data) { CSV.parse(file_fixture('fm-calculator-test-data.csv').read, headers: true) }

  before do
    @rates = CCS::FM::Rate.read_benchmark_rates
  end

  describe 'FM Calculator' do
    it 'FMCalcFMulator for sum' do
      json_list = json_test_data
      csv_table = csv_test_data
      rates = @rates
      
      
      
      X1 = FMCalculator::Calculator.new(3, 'G1', 23000, 125, true, 'Y', 'Y', 'N', rates).sumunitofmeasure
      expect(X1.round(0)).to eq(1341251)

      X2 = FMCalculator::Calculator.new(3, 'C5', 54, 0, true, 'Y', 'Y', 'N', rates).sumunitofmeasure
      expect(X2.round(0)).to eq(54280)

      X3 = FMCalculator::Calculator.new(3, 'C19', 0, 0, true, 'Y', 'Y', 'N', rates).sumunitofmeasure
      expect(X3.round(0)).to eq(0)

      X4 = FMCalculator::Calculator.new(3, 'E4', 450, 0, false, 'N', 'N', 'Y', rates).sumunitofmeasure
      expect(X4.round(0)).to eq(1340)

      X5 = FMCalculator::Calculator.new(3, 'K1', 75, 0, false, 'N', 'N', 'Y', rates).sumunitofmeasure
      expect(X5.round(0)).to eq(26360)

      X6 = FMCalculator::Calculator.new(3, 'H4', 2350, 0, false, 'N', 'N', 'Y', rates).sumunitofmeasure
      expect(X6.round(0)).to eq(173929)

      X7 = FMCalculator::Calculator.new(3, 'G5', 56757, 0, false, 'N', 'N', 'N', rates).sumunitofmeasure
      expect(X7.round(0)).to eq(536629)

      X8 = FMCalculator::Calculator.new(3, 'K2', 125, 0, false, 'N', 'N', 'N', rates).sumunitofmeasure
      expect(X8.round(0)).to eq(101481)

      X9 = FMCalculator::Calculator.new(3, 'K7', 680, 0, false, 'N', 'N', 'N', rates).sumunitofmeasure
      expect(X9.round(0)).to eq(57682)

      Y1 = FMCalculator::Calculator.new(3, 'G1', 23000, 125, true, 'Y', 'Y', 'N', rates).benchmarkedcostssum
      expect(Y1.round(0)).to eq(600241)

      Y2 = FMCalculator::Calculator.new(3, 'C5', 54, 0, true, 'Y', 'Y', 'N', rates).benchmarkedcostssum
      expect(Y2.round(0)).to eq(55712)

      Y3 = FMCalculator::Calculator.new(3, 'C19', 0, 0, true, 'Y', 'Y', 'N', rates).benchmarkedcostssum
      expect(Y3.round(0)).to eq(0)

      Y4 = FMCalculator::Calculator.new(3, 'E4', 450, 0, true, 'N', 'N', 'Y', rates).benchmarkedcostssum
      expect(Y4.round(0)).to eq(1516)

      Y5 = FMCalculator::Calculator.new(3, 'K1', 75, 0, true, 'N', 'N', 'Y', rates).benchmarkedcostssum
      expect(Y5.round(0)).to eq(29806)

      Y6 = FMCalculator::Calculator.new(3, 'H4', 2350, 0, true, 'N', 'N', 'Y', rates).benchmarkedcostssum
      expect(Y6.round(0)).to eq(196663)

      Y7 = FMCalculator::Calculator.new(3, 'G5', 56757, 0, true, 'N', 'N', 'N', rates).benchmarkedcostssum
      expect(Y7.round(0)).to eq(606772)

      Y8 = FMCalculator::Calculator.new(3, 'K2', 125, 0, true, 'N', 'N', 'N', rates).benchmarkedcostssum
      expect(Y8.round(0)).to eq(114746)

      Y9 = FMCalculator::Calculator.new(3, 'K7', 680, 0, true, 'N', 'N', 'N', rates).benchmarkedcostssum
      expect(Y9.round(0)).to eq(65222)

      SumX = X1 + X2 + X3 + X4 + X5 + X6 + X7 + X8 + X9
      expect(SumX.round(0)).to eq(2292953)

      SumY = Y1 + Y2 + Y3 + Y4 + Y5 + Y6 + Y7 + Y8 + Y9
      expect(SumY.round(0)).to eq(1670677)
    end
  end
end
# rubocop:enable all
