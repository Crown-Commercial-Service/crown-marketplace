require 'rails_helper'

RSpec.describe 'management_consultancy/suppliers/_supplier.html.erb' do
  helper(TelephoneNumberHelper)

  let(:contact_name) { 'contact-name' }
  let(:contact_email) { 'contact@example.com' }
  let(:telephone_number) { '01214960123' }

  let(:supplier) do
    create(
      :management_consultancy_supplier,
      contact_name: contact_name,
      contact_email: contact_email,
      telephone_number: telephone_number
    )
  end
  let(:services) { [] }

  before do
    allow(supplier).to receive(:services_in_lot).and_return(services)
    render 'management_consultancy/suppliers/supplier', supplier: supplier, lot_number: '1'
  end

  it 'displays the supplier name' do
    expect(rendered).to have_text(supplier.name)
  end

  context 'when the supplier is an SME' do
    before do
      supplier.update(sme: true)
      render 'management_consultancy/suppliers/supplier', supplier: supplier, lot_number: '1'
    end

    it 'displays the SME label' do
      expect(rendered).to have_text('SME')
    end
  end
end
