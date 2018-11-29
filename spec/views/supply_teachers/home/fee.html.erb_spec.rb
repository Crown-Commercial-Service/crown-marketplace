require 'rails_helper'

RSpec.describe 'supply_teachers/home/fee.html.erb' do
  let(:calculator) do
    options = {
      early_hire_fee: 0,
      daily_supplier_fee: 0,
      markup_rate: 0,
      day_rate: 0,
      working_days: 0,
      contract_start_date: Date.parse('2018-11-19'),
      hire_date: Date.parse('2018-11-26'),
      days_per_week: 0,
      fee_for_early_hire?: nil,
      fee_for_lack_of_notice?: nil,
      before_national_deal_began?: nil,
      ideal_hire_date: Date.parse('2018-11-26'),
      ideal_notice_date: Date.parse('2018-11-26')
    }
    instance_double(TempToPermCalculator::Calculator, options)
  end

  before do
    assign(:calculator, calculator)
  end

  it 'does not display explanatory text if school will not incur early hire fee' do
    allow(calculator).to receive(:fee_for_early_hire?).and_return(false)

    render

    expect(rendered).not_to have_text(/Early Hire Fee calculation/)
  end

  it 'displays explanatory text if school will incur early hire fee' do
    allow(calculator).to receive(:fee_for_early_hire?).and_return(true)

    render

    expect(rendered).to have_text(/The fee calculation is based/)
  end

  it 'displays explanatory text if the contract start date is before the national deal began' do
    allow(calculator).to receive(:before_national_deal_began?).and_return(true)

    render

    expect(rendered).to have_text(/before the National Deal was awarded/)
  end

  it 'does not display explanatory text if the contract start date is after the national deal began' do
    allow(calculator).to receive(:before_national_deal_began?).and_return(false)

    render

    expect(rendered).not_to have_text(/before the National Deal was awarded/)
  end

  it 'does not display explanatory text if school will not incur fee for lack of notice' do
    allow(calculator).to receive(:fee_for_lack_of_notice?).and_return(false)

    render

    expect(rendered).not_to have_text(/fee for lack of notice/)
  end

  it 'displays explanatory text if school might incur fee for lack of notice' do
    allow(calculator).to receive(:fee_for_lack_of_notice?).and_return(true)

    render

    expect(rendered).to have_text(/fee for lack of notice/)
  end
end
