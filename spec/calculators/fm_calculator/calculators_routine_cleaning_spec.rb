require 'rails_helper'
require 'fm_calculator/calculator'

RSpec.describe FMCalculator::Calculator do
  let(:rates) { CCS::FM::Rate.read_benchmark_rates }

  let(:calc) do
    # args  Service ref, uom_vol, occupants, tuoe involved, london_location, CAFM, helpdesk
    described_class.new(3, 'G1', 23000, 125, 'Y', 'Y', 'Y', 'N', rates)
  end

  describe 'calculate routine cleaning', type: :model do
    # rubocop:disable RSpec/ExampleLength:
    # rubocop:disable RSpec/MultipleExpectations:
    it 'calculate routine cleaning assessed value' do
      uomd = calc.uomd
      expect(uomd.round(0)).to eq(277491)
      clean = calc.clean
      expect(clean.round(0)).to eq(3276)
      subtotal1 = uomd + clean
      expect(subtotal1.round(0)).to eq(280767)
      variance = calc.variance(subtotal1)
      expect(variance.round(0)).to eq(52816)
      subtotal2 = subtotal1 + variance
      expect(subtotal2.round(0)).to eq(333583)
      cafm = calc.cafm(subtotal2)
      expect(cafm.round(0)).to eq(4850)
      helpdesk = calc.helpdesk(subtotal2)
      expect(helpdesk.round(0)).to eq(0)
      subtotal3 = subtotal2 + cafm + helpdesk
      expect(subtotal3.round(0)).to eq(338433)
      mobilisation = calc.mobilisation(subtotal3)
      expect(mobilisation.round(0)).to eq(21998)
      tupe = calc.tupe(subtotal3)
      expect(tupe.round(0)).to eq(35142)
      year1 = subtotal3 + mobilisation + tupe
      expect(year1.round(0)).to eq(395573)
      manage = calc.manage(year1)
      expect(manage.round(0)).to eq(39915)
      corporate = calc.corporate(year1)
      expect(corporate.round(0)).to eq(16614)
      year1total = year1 + manage + corporate
      expect(year1total.round(0)).to eq(452102)
      profit = calc.profit(year1)
      expect(profit.round(0)).to eq(12263)
      year1totalcharges = year1total + profit
      expect(year1totalcharges.round(0)).to eq(464364)
      subyearstotal = calc.subyearstotal(year1totalcharges, mobilisation)
      expect(subyearstotal.round(0)).to eq(876887)
      totalcharges = year1totalcharges + subyearstotal
      expect(totalcharges.round(0)).to eq(1341251)
    end
    # rubocop:enable RSpec/MultipleExpectations:
    # rubocop:enable RSpec/ExampleLength:

    # rubocop:disable RSpec/ExampleLength:
    # rubocop:disable RSpec/MultipleExpectations:
    it 'calculate routine cleaning benchmark value' do
      # -------------------------------------- Benchmarked Costs ----------------------------------------------
      benchmarkedcosts = calc.benchmarkedcosts
      expect(benchmarkedcosts.round(0)).to eq(119144)
      benchclean = calc.benchclean
      expect(benchclean.round(0)).to eq(3276)
      benchsubtotal1 = benchmarkedcosts + benchclean
      expect(benchsubtotal1.round(0)).to eq(122421)
      benchvariation = calc.benchvariation(benchsubtotal1)
      expect(benchvariation.round(0)).to eq(23029)
      benchsubtotal2 = benchsubtotal1 + benchvariation
      expect(benchsubtotal2.round(0)).to eq(145449)
      benchcafm = calc.benchcafm(benchsubtotal2)
      expect(benchcafm.round(0)).to eq(2115)
      benchhelpdesk = calc.benchhelpdesk(benchsubtotal2)
      benchsubtotal3 = benchsubtotal2 + benchcafm + benchhelpdesk
      expect(benchsubtotal3.round(0)).to eq(147564)
      benchmobilisation = calc.benchmobilisation(benchsubtotal3)
      expect(benchmobilisation.round(0)).to eq(9592)
      benchtupe = calc.benchtupe(benchsubtotal3)
      expect(benchtupe.round(0)).to eq(15323)
      benchyear1 = benchsubtotal3 + benchmobilisation + benchtupe
      expect(benchyear1.round(0)).to eq(172478)
      benchmanage = calc.benchmanage(benchyear1)
      expect(benchmanage.round(0)).to eq(17404)
      benchcorporate = calc.benchcorporate(benchyear1)
      expect(benchcorporate.round(0)).to eq(7244)
      benchyear1total = benchyear1 + benchmanage + benchcorporate
      expect(benchyear1total.round(0)).to eq(197126)
      benchprofit = calc.benchprofit(benchyear1)
      expect(benchprofit.round(0)).to eq(5347)
      benchyear1totalcharges = benchyear1total + benchprofit
      expect(benchyear1totalcharges.round(0)).to eq(202473)
      benchsubyearstotal = calc.benchsubyearstotal(benchyear1totalcharges, benchmobilisation)
      expect(benchsubyearstotal.round(0)).to eq(382342)
      benchtotalcharges = benchyear1totalcharges + benchsubyearstotal
      expect(benchtotalcharges.round(0)).to eq(584815)
    end
    # rubocop:enable RSpec/MultipleExpectations:
    # rubocop:enable RSpec/ExampleLength:
  end
end
