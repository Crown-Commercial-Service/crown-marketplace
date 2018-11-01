require 'rails_helper'

RSpec.describe 'facilities_management_suppliers/lot1c_suppliers.html.erb' do
  let(:supplier1) { build(:facilities_management_supplier) }
  let(:supplier2) { build(:facilities_management_supplier) }
  let(:suppliers) { [supplier1, supplier2] }

  it 'displays the number of suppliers in the lot' do
    assign(:suppliers, suppliers)
    render
    expect(rendered).to include('2 suppliers')
  end
end
