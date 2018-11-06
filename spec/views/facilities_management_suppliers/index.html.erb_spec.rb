require 'rails_helper'

RSpec.describe 'facilities_management_suppliers/index.html.erb' do
  let(:supplier1) { build(:facilities_management_supplier) }
  let(:supplier2) { build(:facilities_management_supplier) }
  let(:suppliers) { [supplier1, supplier2] }
  let(:lot_number) { '1a' }
  let(:lot) { FacilitiesManagement::Lot.find_by(number: lot_number) }

  before do
    allow(view).to receive(:contract_value_range_text)
      .with(lot_number).and_return('contract-value-range-text')
    assign(:suppliers, suppliers)
    assign(:lot, lot)
    render
  end

  it 'displays the lot number' do
    expect(rendered).to have_text('Lot 1a suppliers')
  end

  it 'displays the contract value range' do
    expect(rendered).to have_text('contract-value-range-text')
  end

  it 'displays the number of suppliers in the lot' do
    expect(rendered).to have_text('2 suppliers')
  end
end
