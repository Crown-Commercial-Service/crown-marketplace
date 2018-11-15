require 'rails_helper'

RSpec.describe 'management_consultancy/suppliers/_supplier.html.erb' do
  helper(TelephoneNumberHelper)

  let(:contact_name) { 'contact-name' }
  let(:contact_email) { 'contact@example.com' }
  let(:telephone_number) { '01214960123' }

  let(:supplier) do
    build(
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

  it 'displays the supplier contact name' do
    expect(rendered).to have_text(contact_name)
  end

  it 'displays the supplier contact email' do
    expect(rendered).to have_text(contact_email)
  end

  it 'displays the formatted supplier telephone number' do
    expect(rendered).to have_text('0121 496 0123')
  end

  context 'when supplier contact name is not available' do
    let(:contact_name) { nil }

    it 'displays message explaining absence of contact name' do
      expect(rendered).to have_text('Contact name not available')
    end
  end

  context 'when supplier contact email is not available' do
    let(:contact_email) { nil }

    it 'displays message explaining absence of contact email' do
      expect(rendered).to have_text('Contact email not available')
    end
  end

  context 'when supplier telephone number is not available' do
    let(:telephone_number) { nil }

    it 'displays message explaining absence of telephone number' do
      expect(rendered).to have_text('Telephone number not available')
    end
  end

  context 'when supplier has multiple services' do
    let(:service1) { ManagementConsultancy::Service.new(name: 'service-1') }
    let(:service2) { ManagementConsultancy::Service.new(name: 'service-2') }

    let(:services) { [service1, service2] }

    it 'displays both services' do
      expect(rendered).to have_text(
        /service-1\s+service-2/
      )
    end
  end
end
