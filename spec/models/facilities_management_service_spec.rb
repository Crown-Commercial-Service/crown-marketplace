require 'rails_helper'

RSpec.describe FacilitiesManagementService, type: :model do
  subject(:services) { described_class.all }

  let(:first_service) { services.first }

  it 'loads services from CSV' do
    expect(services.count).to eq(135)
  end

  it 'populates attributes of first service' do
    expect(first_service.code).to eq('A.7')
    expect(first_service.name).to eq('Accessibility Services')
    expect(first_service.work_package_code).to eq('A')
  end

  it 'looks up work package based on its code' do
    work_package = first_service.work_package
    expect(work_package.code).to eq('A')
    expect(work_package.name).to eq('Contract Management')
  end
end
