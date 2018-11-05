require 'rails_helper'

RSpec.describe 'facilities_management_suppliers/_supplier.html.erb' do
  let(:supplier) { build(:facilities_management_supplier) }

  before do
    render 'facilities_management_suppliers/supplier', supplier: supplier
  end

  it 'displays the supplier name' do
    expect(rendered).to have_text(supplier.name)
  end

  it 'displays the supplier contact name' do
    expect(rendered).to have_text(supplier.contact_name)
  end

  it 'displays the supplier contact email' do
    expect(rendered).to have_text(supplier.contact_email)
  end

  it 'displays the supplier telephone number' do
    expect(rendered).to have_text(supplier.telephone_number)
  end
end
