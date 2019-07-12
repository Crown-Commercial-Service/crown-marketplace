require 'rails_helper'
require 'fm_calculator/calculator'

# rubocop:disable all

  RSpec.describe FMCalculator::Calculator do
    subject(:calculator) do
    end

    before(:each) do
      # args  Service ref, uom_vol, occupants, tuoe involved, london_location, CAFM, helpdesk
      rates = CCS::FM::Rate.read_benchmark_rates
      @calc = described_class.new(rates, 3, 'G1', 23000, 125, 'Y', 'Y', 'Y', 'N')
    end

    describe 'calculate routine cleaning'
    it 'calculate routine cleaning' do

      x = @calc.uomd
      expect(x.round(0)).to eq(277491)
      x = @calc.clean
      expect(x.round(0)).to eq(3276)
      x = @calc.subtotal1
      expect(x.round(0)).to eq(280767)
      x = @calc.variance
      expect(x.round(0)).to eq(52816)
      x = @calc.subtotal2
      expect(x.round(0)).to eq(333583)
      x = @calc.cafm
      expect(x.round(0)).to eq(4850)
      x = @calc.helpdesk
      expect(x.round(0)).to eq(0)
      x = @calc.subtotal3
      expect(x.round(0)).to eq(338433)
      x = @calc.mobilisation
      expect(x.round(0)).to eq(21998)
      x = @calc.tupe
      expect(x.round(0)).to eq(35142)
      x = @calc.year1
      expect(x.round(0)).to eq(395573)
      x = @calc.manage
      expect(x.round(0)).to eq(39915)
      x = @calc.corporate
      expect(x.round(0)).to eq(19709)
      x = @calc.year1total
      expect(x.round(0)).to eq(455197)
      x = @calc.profit
      expect(x.round(0)).to eq(21472)
      x = @calc.year1totalcharges
      expect(x.round(0)).to eq(476668)
      x = @calc.subyearstotal
      x = @calc.totalcharges
      # expect(x).to eq(899962)
      # expect(x).to eq(1376631)
    # -------------------------------------- Benchmarked Costs ----------------------------------------------
      x = @calc.benchmarkedcosts
      # expect(x).to eq(119144)
      x = @calc.benchclean
      # expect(x).to eq(3276)
      x = @calc.benchsubtotal1
      # expect(x).to eq(122420)
      x = @calc.benchvariation
      # expect(x).to eq(23029)
      x = @calc.benchsubtotal2
      # expect(x).to eq(145449)
      x = @calc.benchcafm
      # expect(x).to eq(0)
      # expect(x).to eq(2115)
      x = @calc.benchhelpdesk
      x = @calc.benchsubtotal3
      # expect(x).to eq(147564)
      x = @calc.benchmobilisation
      # expect(x).to eq(9592)
      x = @calc.benchtupe
      # expect(x).to eq(15323)
      x = @calc.benchyear1
      # expect(x).to eq(172479)
      x = @calc.benchmanage
      # expect(x).to eq(17404)
      x = @calc.benchcorporate
      # expect(x).to eq(8594)
      x = @calc.benchyear1total
      # expect(x).to eq(198477)
      x = @calc.benchprofit
      # expect(x).to eq(9362)
      x = @calc.benchyear1totalcharges
      # expect(x).to eq(207839)
      x = @calc.benchsubyearstotal
      # expect(x).to eq(392404)
      x = @calc.benchtotalcharges
      # expect(x).to eq(600243)
  end
end
# rubocop:enable all