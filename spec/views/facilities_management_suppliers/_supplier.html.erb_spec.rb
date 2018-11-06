require 'rails_helper'

RSpec.describe 'facilities_management_suppliers/_supplier.html.erb' do
  let(:contact_name) { 'contact-name' }
  let(:contact_email) { 'contact@example.com' }

  let(:supplier) do
    build(
      :facilities_management_supplier,
      contact_name: contact_name,
      contact_email: contact_email
    )
  end

  let(:services) { {} }

  before do
    allow(supplier).to receive(:services_by_work_package_in_lot).and_return(services)
    render 'facilities_management_suppliers/supplier', supplier: supplier, lot_number: '1a'
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

  context 'when supplier has multiple services in one work package' do
    let(:work_package) { FacilitiesManagement::WorkPackage.new(name: 'work-package') }
    let(:service1) do
      FacilitiesManagement::Service.new(name: 'service-1', mandatory: 'true')
    end
    let(:service2) do
      FacilitiesManagement::Service.new(name: 'service-2', mandatory: 'false')
    end

    let(:services) do
      {
        work_package => [service1, service2]
      }
    end

    it 'displays both services within the work package grouped by type' do
      expect(rendered).to have_text(
        /work-package\s+Basic services\s+service-1\s+Extra services\s+service-2/
      )
    end
  end

  context 'when supplier has one service in two different work packages' do
    let(:work_package1) { FacilitiesManagement::WorkPackage.new(name: 'work-package-1') }
    let(:work_package2) { FacilitiesManagement::WorkPackage.new(name: 'work-package-2') }
    let(:service1) do
      FacilitiesManagement::Service.new(name: 'service-1', mandatory: 'true')
    end
    let(:service2) do
      FacilitiesManagement::Service.new(name: 'service-2', mandatory: 'false')
    end

    let(:services) do
      {
        work_package1 => [service1],
        work_package2 => [service2]
      }
    end

    it 'displays each service within the its work package grouped by type' do
      expect(rendered).to have_text(
        /work-package-1\s+Basic services\s+service-1\s+work-package-2\s+Extra services\s+service-2/
      )
    end
  end
end
