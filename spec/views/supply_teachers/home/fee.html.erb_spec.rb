require 'rails_helper'

RSpec.describe 'supply_teachers/home/fee.html.erb' do
  let(:calculator) do
    options = {
      fee: 0,
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
      ideal_notice_date: Date.parse('2018-11-26'),
      notice_period_required?: nil,
      notice_date_based_on_hire_date: Date.parse('2018-11-26')
    }
    instance_double(TempToPermCalculator::Calculator, options)
  end

  before do
    assign(:calculator, calculator)
  end

  describe 'notice period message' do
    let(:notice_string) { /Provided you give notice on or before/ }

    before do
      allow(calculator).to receive(:notice_period_required?).and_return(notice_period_required)
      render
    end

    context 'when notice period is required' do
      let(:notice_period_required) { true }

      it 'is displayed' do
        expect(rendered).to match(notice_string)
      end
    end

    context 'when notice period is not required' do
      let(:notice_period_required) { false }

      it 'is not displayed' do
        expect(rendered).not_to match(notice_string)
      end
    end
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
