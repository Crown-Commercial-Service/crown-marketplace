require 'rails_helper'

RSpec.describe 'branches/index' do
  let(:first_supplier) { Supplier.new(name: 'First Supplier') }
  let(:second_supplier) { Supplier.new(name: 'Second Supplier') }

  let(:first_branch) { first_supplier.branches.build(postcode: 'TN33 0PQ') }
  let(:second_branch) { first_supplier.branches.build(postcode: 'LU7 0JL') }
  let(:third_branch) { second_supplier.branches.build(postcode: 'LS15 8GB') }

  let(:branches) { [first_branch, second_branch, third_branch] }

  # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
  it 'displays list of all branches' do
    assign(:branches, branches)

    render

    page = Capybara.string(rendered)

    expect(page).to have_css('h2.govuk-heading-l', text: /First Supplier/)
    expect(page).to have_css('h2.govuk-heading-l', text: /First Supplier/)
    expect(page).to have_css('h2.govuk-heading-l', text: /Second Supplier/)
  end
  # rubocop:enable RSpec/ExampleLength,RSpec/MultipleExpectations
end
