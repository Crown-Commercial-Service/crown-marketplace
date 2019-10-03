require 'rails_helper'
require 'fm_calculator/calculator'

# rubocop:disable all

  RSpec.describe FMCalculator::Calculator do
    subject(:calculator) do
    end

    before(:each) do
      # args  Service ref, uom_vol, occupants, tuoe involved, london_location, CAFM, helpdesk
      rates = CCS::FM::Rate.read_benchmark_rates
      @calc = described_class.new(3, 'G1', 23000, 125, 'Y', 'Y', 'Y', 'N', rates)
    end

    describe 'calculate routine cleaning'
    it 'calculate routine cleaning' do

      uomd = @calc.uomd
      expect(uomd.round(0)).to eq(277491)
      clean = @calc.clean
      expect(clean.round(0)).to eq(3276)
      subtotal1 = uomd + clean
      expect(subtotal1.round(0)).to eq(280767)
      variance = @calc.variance(subtotal1)
      expect(variance.round(0)).to eq(52816)
      subtotal2 = subtotal1 + variance
      expect(subtotal2.round(0)).to eq(333583)
      cafm = @calc.cafm(subtotal2)
      expect(cafm.round(0)).to eq(4850)
      helpdesk = @calc.helpdesk(subtotal2)
      expect(helpdesk.round(0)).to eq(0)
      subtotal3 = subtotal2 + cafm + helpdesk
      expect(subtotal3.round(0)).to eq(338433)
      mobilisation = @calc.mobilisation(subtotal3)
      expect(mobilisation.round(0)).to eq(21998)
      tupe = @calc.tupe(subtotal3)
      expect(tupe.round(0)).to eq(35142)
      year1 = subtotal3 + mobilisation + tupe
      expect(year1.round(0)).to eq(395573)
      manage = @calc.manage(year1)
      expect(manage.round(0)).to eq(39915)
      corporate = @calc.corporate(year1)
      expect(corporate.round(0)).to eq(19709)
      year1total = year1 + manage + corporate
      expect(year1total.round(0)).to eq(455197)
      profit = @calc.profit(year1)
      expect(profit.round(0)).to eq(21472)
      year1totalcharges = year1total + profit
      expect(year1totalcharges.round(0)).to eq(476668)
      subyearstotal = @calc.subyearstotal(year1totalcharges, mobilisation)
      expect(subyearstotal.round(0)).to eq(899961)
      totalcharges = year1totalcharges + subyearstotal
      expect(totalcharges.round(0)).to eq(1376629)
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