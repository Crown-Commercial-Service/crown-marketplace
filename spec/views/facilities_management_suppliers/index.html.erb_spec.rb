require 'rails_helper'

RSpec.describe 'facilities_management_suppliers/index.html.erb' do
  let(:supplier1) { build(:facilities_management_supplier) }
  let(:supplier2) { build(:facilities_management_supplier) }
  let(:suppliers) { [supplier1, supplier2] }
  let(:lot_number) { '1a' }

  before do
    allow(view).to receive(:contract_value_range_text)
      .with(lot_number).and_return('contract-value-range-text')
    assign(:suppliers, suppliers)
    assign(:lot, lot_number)
    render
  end

  it 'displays the lot number' do
    expect(rendered).to include('Lot 1a')
  end

  it 'displays the contract value range' do
    expect(rendered).to include('contract-value-range-text')
  end

  it 'displays the number of suppliers in the lot' do
    expect(rendered).to include('2 suppliers')
  end

  it 'displays the supplier name' do
    expect(rendered).to include(supplier1.name)
  end

  it 'displays the supplier contact name' do
    expect(rendered).to include(supplier1.contact_name)
  end

  it 'displays the supplier contact email' do
    expect(rendered).to include(supplier1.contact_email)
  end

  it 'displays the supplier telephone number' do
    expect(rendered).to include(supplier1.telephone_number)
  end
end
