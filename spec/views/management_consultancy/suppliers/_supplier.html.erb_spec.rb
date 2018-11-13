require 'rails_helper'

RSpec.describe 'management_consultancy/suppliers/_supplier.html.erb' do
  let(:supplier) { build(:management_consultancy_supplier) }
  let(:services) { [] }

  before do
    allow(supplier).to receive(:services_in_lot).and_return(services)
    render 'management_consultancy/suppliers/supplier', supplier: supplier, lot_number: '1'
  end

  it 'displays the supplier name' do
    expect(rendered).to have_text(supplier.name)
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
