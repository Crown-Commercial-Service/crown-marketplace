require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementBuilding, type: :model do
  subject(:procurement_building) { build(:facilities_management_procurement_building, procurement: create(:facilities_management_procurement)) }

  describe '#validations' do
    context 'when inactive and service_codes empty' do
      it 'is valid' do
        procurement_building.active = false
        procurement_building.service_codes = []
        expect(procurement_building.valid?(:building_services)).to eq true
      end
    end

    context 'when inactive and service_codes not empty' do
      it 'is valid' do
        procurement_building.active = false
        procurement_building.service_codes = ['test']
        expect(procurement_building.valid?(:building_services)).to eq true
      end
    end

    context 'when active and service_codes empty' do
      it 'is invalid' do
        procurement_building.active = true
        procurement_building.service_codes = []
        expect(procurement_building.valid?(:building_services)).to eq false
      end
    end

    context 'when active and service_codes not empty' do
      it 'is valid' do
        procurement_building.active = true
        procurement_building.service_codes = ['test']
        expect(procurement_building.valid?(:building_services)).to eq true
      end
    end
  end
end
