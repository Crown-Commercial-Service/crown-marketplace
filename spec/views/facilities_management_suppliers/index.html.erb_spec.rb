require 'rails_helper'

RSpec.describe 'facilities_management_suppliers/index.html.erb' do
  let(:supplier1) { build(:facilities_management_supplier) }
  let(:supplier2) { build(:facilities_management_supplier) }
  let(:suppliers) { [supplier1, supplier2] }

  before do
    assign(:suppliers, suppliers)
    render
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
