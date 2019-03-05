require 'rails_helper'

RSpec.describe 'supply_teachers/home/_avoid_paying_fees.html.erb' do
  let(:calculator) do
    instance_double(
      'TempToPermCalculator::Calculator',
      hiring_after_12_weeks?: false,
      ideal_notice_date: ideal_notice_date,
      ideal_hire_date: ideal_hire_date
    )
  end

  before do
    assign(:calculator, calculator)
    render 'supply_teachers/home/avoid_paying_fees'
  end

  context 'when the ideal notice date is in the past' do
    let(:ideal_notice_date) { 5.months.ago }
    let(:ideal_hire_date) { 4.months.ago }

    it 'displays a generic notice to notify the agency' do
      expect(rendered).to have_content('give notice to the agency as soon as possible and')
      expect(rendered).to have_content('make the worker permanent 4 working weeks after that date')
    end
  end

  context 'when the ideal notice date is in the future' do
    let(:ideal_notice_date) { 2.months.from_now }
    let(:ideal_hire_date) { 3.months.from_now }

    it 'displays the ideal hire and notice dates' do
      expect(rendered).to have_content(
        "You could give notice to the agency on #{ideal_notice_date.to_formatted_s(:long_with_day)} "\
        "and make the worker permanent on #{ideal_hire_date.to_formatted_s(:long_with_day)}"
      )
    end
  end
end