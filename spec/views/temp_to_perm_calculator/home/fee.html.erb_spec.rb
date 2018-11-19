require 'rails_helper'

RSpec.describe 'temp_to_perm_calculator/home/fee.html.erb' do
  let(:calculator) do
    options = {
      fee: 0,
      daily_supplier_fee: 0,
      markup_rate: 0,
      day_rate: 0,
      working_days: 0,
      contract_start_date: Date.parse('2018-11-19'),
      hire_date: Date.parse('2018-11-26'),
      days_per_week: 0
    }
    instance_double(TempToPermCalculator::Calculator, options)
  end

  before do
    assign(:calculator, calculator)
  end

  it 'displays explanatory text if school might incur fee for lack of notice' do
    allow(calculator).to receive(:fee_for_lack_of_notice?).and_return(true)

    render

    expect(rendered).to have_text(/fee for lack of notice/)
  end
end
