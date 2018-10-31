require 'rails_helper'

RSpec.describe FacilitiesManagementSupplier, type: :model do
  subject(:supplier) { build(:facilities_management_supplier) }

  it { is_expected.to be_valid }

  it 'is not valid if name is blank' do
    supplier.name = ''
    expect(supplier).not_to be_valid
  end

  it 'is not valid if contact_name is blank' do
    supplier.contact_name = ''
    expect(supplier).not_to be_valid
  end
end
