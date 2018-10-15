require 'rails_helper'

RSpec.describe 'branches/index.html.erb' do
  let(:first_supplier) { build(:supplier, name: 'First Supplier') }
  let(:second_supplier) { build(:supplier, name: 'Second Supplier') }

  let(:first_branch) do
    build(:branch, supplier: first_supplier, name: 'First Branch')
  end
  let(:second_branch) do
    build(:branch, supplier: first_supplier, name: 'Second Branch')
  end
  let(:third_branch) do
    build(:branch, supplier: second_supplier, name: 'Third Branch')
  end

  let(:nominated_worker_rate) { nil }

  let(:branches) { [first_branch, second_branch, third_branch] }
  let(:point) { nil }
  let(:postcode) { nil }

  before do
    assign(:branches, branches)
    assign(:point, point)
    assign(:postcode, postcode)

    allow(first_supplier).to receive(:nominated_worker_rate).and_return(nominated_worker_rate)
    allow(second_supplier).to receive(:nominated_worker_rate).and_return(nominated_worker_rate)

    render
  end

  it 'displays headings for suppliers for each branch' do
    page = Capybara.string(rendered)

    expect(page).to have_css('h2.govuk-heading-l', text: /First Supplier/, count: 2)
    expect(page).to have_css('h2.govuk-heading-l', text: /Second Supplier/)
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

  context 'when there are no branches' do
    let(:branches) { [] }

    it 'does not display empty list' do
      page = Capybara.string(rendered)
      expect(page).not_to have_css('ol')
    end
  end

  context 'when displaying branches near the buyers location' do
    let(:point) { instance_double('RGeo::Geographic::SphericalPointImpl', distance: 1) }
    let(:postcode) { 'W1A 1AA' }
    let(:rates) { [build(:rate, job_type: 'nominated')] }
    let(:nominated_worker_rate) { 1 }

    it 'adds location context to the number of results' do
      expect(rendered).to have_content('3 results found within 25 miles of W1A 1AA')
    end
  end
end
