require 'rails_helper'

RSpec.describe FacilitiesManagementServiceOffering, type: :model do
  subject(:service_offering) { build(:facilities_management_service_offering) }

  it { is_expected.to be_valid }

  it 'is not valid if lot_number is blank' do
    service_offering.lot_number = ''
    expect(service_offering).not_to be_valid
  end

  it 'is not valid if service_code is blank' do
    service_offering.service_code = ''
    expect(service_offering).not_to be_valid
  end

  it 'can be associated with one facilities management supplier' do
    supplier = build(:facilities_management_supplier)
    offering = supplier.service_offerings.build
    expect(offering.supplier).to eq(supplier)
  end
end
