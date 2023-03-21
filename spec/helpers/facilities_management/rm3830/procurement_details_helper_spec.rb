require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::ProcurementDetailsHelper do
  describe '.page_subtitle' do
    before { @procurement = create(:facilities_management_rm3830_procurement_no_procurement_buildings, contract_name: 'Zeon') }

    it 'returns the contract name' do
      expect(helper.page_subtitle).to eq('Zeon')
    end
  end

  describe '.porcurement_services' do
    before { @procurement = create(:facilities_management_rm3830_procurement_no_procurement_buildings, service_codes: %w[C.1 D.1 F.1]) }

    it 'returns the service names' do
      expect(helper.porcurement_services).to eq(['Mechanical and electrical engineering maintenance', 'Grounds maintenance services', 'Chilled potable water'])
    end
  end

  describe '.building_name' do
    let(:building) { create(:facilities_management_building, user: user, building_name: 'Super building name') }
    let(:procurement) { create(:facilities_management_rm3830_procurement_entering_requirements, user: user) }
    let(:procurement_building) { create(:facilities_management_rm3830_procurement_building_no_services, procurement: procurement, building: building) }
    let(:user) { create(:user) }

    it 'returns the building name' do
      expect(helper.building_name(procurement_building)).to eq('Super building name')
    end
  end
end
