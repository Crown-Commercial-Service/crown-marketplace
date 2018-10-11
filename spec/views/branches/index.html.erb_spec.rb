require 'rails_helper'

RSpec.describe 'branches/index.html.erb' do
  let(:first_supplier) { build(:supplier, name: 'First Supplier') }
  let(:second_supplier) { build(:supplier, name: 'Second Supplier') }

  let(:first_branch) do
    build(:branch, supplier: first_supplier, postcode: 'TN33 0PQ')
  end
  let(:second_branch) do
    build(:branch, supplier: first_supplier, postcode: 'LU7 0JL')
  end
  let(:third_branch) do
    build(:branch, supplier: second_supplier, postcode: 'LS15 8GB')
  end

  let(:branches) { [first_branch, second_branch, third_branch] }
  let(:point) { nil }
  let(:postcode) { nil }

  before do
    assign(:branches, branches)
    assign(:point, point)
    assign(:postcode, postcode)

    render
  end

  it 'displays list of all branches' do
    page = Capybara.string(rendered)

    expect(page).to have_css('h2.govuk-heading-l', text: /First Supplier/)
    expect(page).to have_css('h2.govuk-heading-l', text: /First Supplier/)
    expect(page).to have_css('h2.govuk-heading-l', text: /Second Supplier/)
  end

  it 'displays number of results' do
    expect(rendered).to have_content('3 results found')
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

    it 'adds location context to the number of results' do
      expect(rendered).to have_content('3 results found within 25 miles of W1A 1AA')
    end
  end
end
