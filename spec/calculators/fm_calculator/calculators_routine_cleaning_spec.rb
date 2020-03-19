require 'rails_helper'
require 'fm_calculator/calculator'

RSpec.describe FMCalculator::Calculator do
  let(:rates) { CCS::FM::Rate.read_benchmark_rates }

  let(:calc) do
    # args  Service ref, uom_vol, occupants, tuoe involved, london_location, CAFM, helpdesk
    described_class.new(3, 'G1', 23000, 125, true, true, true, false, CCS::FM::Rate.read_benchmark_rates, CCS::FM::RateCard.latest)
  end

  describe 'calculate routine cleaning', type: :model do
    # rubocop:disable RSpec/ExampleLength:
    # rubocop:disable RSpec/MultipleExpectations:
    it 'calculate routine cleaning assessed value' do
      uomd = calc.uomd
      expect(uomd.round(2)).to eq(277380.0)
      clean = calc.clean
      expect(clean.round(2)).to eq(3276.25)
      subtotal1 = uomd + clean
      expect(subtotal1.round(2)).to eq(280656.25)
      variance = calc.variance(subtotal1)
      expect(variance.round(2)).to eq(52791.44)
      subtotal2 = subtotal1 + variance
      expect(subtotal2.round(2)).to eq(333447.69)
      cafm = calc.cafm(subtotal2)
      expect(cafm.round(2)).to eq(4834.99)
      helpdesk = calc.helpdesk(subtotal2)
      expect(helpdesk.round(2)).to eq(0.00)
      subtotal3 = subtotal2 + cafm + helpdesk
      expect(subtotal3.round(2)).to eq(338282.68)
      mobilisation = calc.mobilisation(subtotal3)
      expect(mobilisation.round(2)).to eq(0.00)
      tupe = calc.tupe(subtotal3)
      expect(tupe.round(2)).to eq(35113.74)
      year1 = subtotal3 + mobilisation + tupe
      expect(year1.round(2)).to eq(373396.42)
      manage = calc.manage(year1)
      expect(manage.round(2)).to eq(37675.7)
      corporate = calc.corporate(year1)
      expect(corporate.round(2)).to eq(18595.14)
      year1total = year1 + manage + corporate
      expect(year1total.round(2)).to eq(429667.27)
      profit = calc.profit(year1)
      expect(profit.round(2)).to eq(20275.43)
      year1totalcharges = year1total + profit
      expect(year1totalcharges.round(2)).to eq(449942.69)
      subyearstotal = calc.subyearstotal(year1totalcharges, mobilisation)
      expect(subyearstotal.round(2)).to eq(899885.38)
      totalcharges = year1totalcharges + subyearstotal
      expect(totalcharges.round(2)).to eq(1349828.07)
    end
    # rubocop:enable RSpec/MultipleExpectations:
    # rubocop:enable RSpec/ExampleLength:

    # rubocop:disable RSpec/ExampleLength:
    # rubocop:disable RSpec/MultipleExpectations:
    it 'calculate routine cleaning benchmark value' do
      # -------------------------------------- Benchmarked Costs ----------------------------------------------
      benchmarkedcosts = calc.benchmarkedcosts
      expect(benchmarkedcosts.round(0)).to eq(119140)
      benchclean = calc.benchclean
      expect(benchclean.round(0)).to eq(3276)
      benchsubtotal1 = benchmarkedcosts + benchclean
      expect(benchsubtotal1.round(0)).to eq(122416)
      benchvariation = calc.benchvariation(benchsubtotal1)
      expect(benchvariation.round(0)).to eq(23026)
      benchsubtotal2 = benchsubtotal1 + benchvariation
      expect(benchsubtotal2.round(0)).to eq(145443)
      benchcafm = calc.benchcafm(benchsubtotal2)
      expect(benchcafm.round(0)).to eq(2109)
      benchhelpdesk = calc.benchhelpdesk(benchsubtotal2)
      benchsubtotal3 = benchsubtotal2 + benchcafm + benchhelpdesk
      expect(benchsubtotal3.round(0)).to eq(147552)
      benchmobilisation = calc.benchmobilisation(benchsubtotal3)
      expect(benchmobilisation.round(0)).to eq(9591)
      benchtupe = calc.benchtupe(benchsubtotal3)
      expect(benchtupe.round(0)).to eq(15316)
      benchyear1 = benchsubtotal3 + benchmobilisation + benchtupe
      expect(benchyear1.round(0)).to eq(172458)
      benchmanage = calc.benchmanage(benchyear1)
      expect(benchmanage.round(0)).to eq(17401)
      benchcorporate = calc.benchcorporate(benchyear1)
      expect(benchcorporate.round(0)).to eq(7243)
      benchyear1total = benchyear1 + benchmanage + benchcorporate
      expect(benchyear1total.round(0)).to eq(197103)
      benchprofit = calc.benchprofit(benchyear1)
      expect(benchprofit.round(0)).to eq(5346)
      benchyear1totalcharges = benchyear1total + benchprofit
      expect(benchyear1totalcharges.round(0)).to eq(202449)
      benchsubyearstotal = calc.benchsubyearstotal(benchyear1totalcharges, benchmobilisation)
      expect(benchsubyearstotal.round(0)).to eq(382295)
      benchtotalcharges = benchyear1totalcharges + benchsubyearstotal
      expect(benchtotalcharges.round(0)).to eq(584744)
    end
    # rubocop:enable RSpec/MultipleExpectations:
    # rubocop:enable RSpec/ExampleLength:
  end
end
