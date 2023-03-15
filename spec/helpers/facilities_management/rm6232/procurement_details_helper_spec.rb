require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::ProcurementDetailsHelper do
  describe '.porcurement_services' do
    before { @procurement = create(:facilities_management_rm6232_procurement_entering_requirements, service_codes: %w[E.1 F.1 Q.3]) }

    it 'returns the service names withou consideration of the lot' do
      expect(helper.porcurement_services).to eq(['Mechanical and Electrical Engineering Maintenance', 'Asbestos Management', 'CAFM system'])
    end
  end

  describe '.building_name' do
    let(:building) { create(:facilities_management_building, user: user, building_name: 'Super building name') }
    let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, user:) }
    let(:procurement_building) { create(:facilities_management_rm6232_procurement_building_no_services, procurement:, building:) }
    let(:user) { create(:user) }

    it 'returns the building name' do
      expect(helper.building_name(procurement_building)).to eq('Super building name')
    end
  end
end
