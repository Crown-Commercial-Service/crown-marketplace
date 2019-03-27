require 'rails_helper'
require 'fm_calculator/calculator'

# rubocop:disable all

RSpec.describe FMCalculator::Calculator do
  subject(:calculator) do
  end

  before(:each) do
    # args  Service ref, uom_vol, occupants, tuoe involved, london_location, CAFM, helpdesk
    Calc = described_class.new('G1', 23000, 125, 'Y', 'Y', 'Y', 'N')
  end

  describe 'calculate routine cleaning'
  it 'calculate routine cleaning' do

    x = Calc.uomd
    expect(x).to eq(277491)
    x = Calc.clean
    expect(x).to eq(3276)
    x = Calc.subtotal1
    expect(x).to eq(280767)
    x = Calc.variance
    expect(x).to eq(52816)
    x = Calc.subtotal2
    expect(x).to eq(333583)
    x = Calc.cafm
    expect(x).to eq(4850)
    x = Calc.helpdesk
    expect(x).to eq(0)
    x = Calc.subtotal3
    expect(x).to eq(338433)
    x = Calc.mobilisation
    expect(x).to eq(21998)
    x = Calc.tupe
    expect(x).to eq(35142)
    x = Calc.year1
    expect(x).to eq(395573)
    x = Calc.manage
    expect(x).to eq(39915)
    x = Calc.corporate
    expect(x).to eq(19709)
    x = Calc.year1total
    expect(x).to eq(455197)
    x = Calc.profit
    expect(x).to eq(21472)
    x = Calc.year1totalcharges
    expect(x).to eq(476669)
    x = Calc.subyearstotal
    expect(x).to eq(899962)
    x = Calc.totalcharges
    expect(x).to eq(1376631)
  # -------------------------------------- Benchmarked Costs ----------------------------------------------
    x = Calc.benchmarkedcosts
    expect(x).to eq(119144)
    x = Calc.benchclean
    expect(x).to eq(3276)
    x = Calc.benchsubtotal1
    expect(x).to eq(122420)
    x = Calc.benchvariation
    expect(x).to eq(23029)
    x = Calc.benchsubtotal2
    expect(x).to eq(145449)
    x = Calc.benchcafm
    expect(x).to eq(2115)
    x = Calc.benchhelpdesk
    expect(x).to eq(0)
    x = Calc.benchsubtotal3
    expect(x).to eq(147564)
    x = Calc.benchmobilisation
    expect(x).to eq(9592)
    x = Calc.benchtupe
    expect(x).to eq(15323)
    x = Calc.benchyear1
    expect(x).to eq(172479)
    x = Calc.benchmanage
    expect(x).to eq(17404)
    x = Calc.benchcorporate
    expect(x).to eq(8594)
    x = Calc.benchyear1total
    expect(x).to eq(198477)
    x = Calc.benchprofit
    expect(x).to eq(9362)
    x = Calc.benchyear1totalcharges
    expect(x).to eq(207839)
    x = Calc.benchsubyearstotal
    expect(x).to eq(392404)
    x = Calc.benchtotalcharges
    expect(x).to eq(600243)
  end
end
# rubocop:enable all

