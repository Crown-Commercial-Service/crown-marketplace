require 'rails_helper'

RSpec.describe 'facilities_management_suppliers/_supplier.html.erb' do
  let(:supplier) { build(:facilities_management_supplier) }
  let(:services) { {} }

  before do
    allow(supplier).to receive(:services_by_work_package_in_lot).and_return(services)
    render 'facilities_management_suppliers/supplier', supplier: supplier, lot_number: '1a'
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

  context 'when supplier has multiple services in one work package' do
    let(:work_package) { FacilitiesManagementWorkPackage.new(name: 'work-package') }
    let(:service1) { FacilitiesManagementService.new(name: 'service-1') }
    let(:service2) { FacilitiesManagementService.new(name: 'service-2') }

    let(:services) do
      {
        work_package => [service1, service2]
      }
    end

    it 'displays both services within the work package' do
      expect(rendered).to have_text(/work-package\s+service-1\s+service-2/)
    end
  end

  context 'when supplier has one service in two different work packages' do
    let(:work_package1) { FacilitiesManagementWorkPackage.new(name: 'work-package-1') }
    let(:work_package2) { FacilitiesManagementWorkPackage.new(name: 'work-package-2') }
    let(:service1) { FacilitiesManagementService.new(name: 'service-1') }
    let(:service2) { FacilitiesManagementService.new(name: 'service-2') }

    let(:services) do
      {
        work_package1 => [service1],
        work_package2 => [service2]
      }
    end

    it 'displays each service within the its work package' do
      expect(rendered).to have_text(/work-package-1\s+service-1\s+work-package-2\s+service-2/)
    end
  end
end
