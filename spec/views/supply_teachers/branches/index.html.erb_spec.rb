require 'rails_helper'

RSpec.describe 'supply_teachers/branches/index.html.erb' do
  helper(TelephoneNumberHelper)

  let(:inputs) do
    {
      looking_for: 'Individual worker',
      worker_type: 'Nominated',
      postcode: 'SW1A 1AA'
    }
  end

  let(:journey) { instance_double('Journey', params: {}, inputs: inputs, previous_questions_and_answers: {}) }
  let(:first_supplier) { build(:supply_teachers_supplier, name: 'First Supplier') }
  let(:second_supplier) { build(:supply_teachers_supplier, name: 'Second Supplier') }

  let(:first_branch) do
    build(:supply_teachers_branch_search_result, name: 'First Branch', supplier_name: 'First Supplier')
  end
  let(:second_branch) do
    build(:supply_teachers_branch_search_result, supplier_name: first_supplier.name, name: 'Second Branch')
  end
  let(:third_branch) do
    build(:supply_teachers_branch_search_result, supplier_name: second_supplier.name, name: 'Third Branch')
  end

  let(:nominated_worker_rate) { nil }

  let(:branches) { [first_branch, second_branch, third_branch] }
  let(:location) { nil }
  let(:link_to_calculator) { true }

  before do
    view.extend(ApplicationHelper)

    assign(:journey, journey)
    assign(:branches, branches)
    assign(:location, location)
    assign(:radius_in_miles, 26)
    assign(:alternative_radiuses, [3, 17])

    allow(first_supplier).to receive(:nominated_worker_rate).and_return(nominated_worker_rate)
    allow(second_supplier).to receive(:nominated_worker_rate).and_return(nominated_worker_rate)
    allow(view).to receive(:link_to_calculator?).and_return(link_to_calculator)

    render
  end

  it 'displays the buyers selection' do
    expect(rendered).to have_css('.govuk-inset-text li', text: /Looking for\: Individual worker/)
    expect(rendered).to have_css('.govuk-inset-text li', text: /Worker type\: Nominated/)
    expect(rendered).to have_css('.govuk-inset-text li', text: /Postcode\: SW1A 1AA/)
  end

  it 'displays headings for suppliers for each branch' do
    expect(rendered).to have_css('h2.govuk-heading-m', text: /First Supplier/, count: 2)
    expect(rendered).to have_css('h2.govuk-heading-m', text: /Second Supplier/)
  end

  it 'displays list of all branches' do
    expect(rendered).to have_content('First Branch')
    expect(rendered).to have_content('Second Branch')
    expect(rendered).to have_content('Third Branch')
  end

  it 'displays number of results' do
    expect(rendered).to have_content('3 results found')
  end

  it 'has a link to print the page' do
    expect(rendered).to have_link('Print this page')
  end

  it 'has a link to download a spreadsheet' do
    expect(rendered).to have_link('Download shortlist of suppliers')
  end

  it 'has a link to download the calculator' do
    expect(rendered).to have_link('Download shortlist (with markup calculator)')
  end

  it 'has a button to calculate the mark-up' do
    expect(rendered).to have_button(I18n.t('supply_teachers.branches.index.calculate_markup_button_label'))
  end

  context 'when shortlisting for teachers on school payroll' do
    let(:link_to_calculator) { false }

    it 'does not have a link to download the calculator' do
      expect(rendered).not_to have_link('Download shortlist (with markup calculator)')
    end

    it 'does not have a button to calculate the mark-up' do
      expect(rendered).not_to have_button(I18n.t('supply_teachers.branches.index.calculate_markup_button_label'))
    end
  end

  context 'when displaying branches near the buyers location' do
    let(:point) { instance_double('RGeo::Geographic::SphericalPointImpl', distance: 1) }
    let(:location) { instance_double('Location', postcode: 'W1A 1AA', point: point) }
    let(:rates) { [build(:supply_teachers_rate, job_type: 'nominated')] }
    let(:nominated_worker_rate) { 1 }

    it 'adds location context to the number of results' do
      expect(rendered).to have_content('3 results found within 26 miles of W1A 1AA')
    end

    it 'offers alternative radiuses' do
      expect(rendered).to have_link('3 miles')
      expect(rendered).to have_link('17 miles')
    end
  end
end
