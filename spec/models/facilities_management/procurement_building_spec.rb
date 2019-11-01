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

  describe 'update_procurement_building_services' do
    context 'when no procurement_building_services exists' do
      it 'creates a new procurement_building_service' do
        procurement_building.active = true
        procurement_building.service_codes = ['test']
        expect { procurement_building.save }.to change(FacilitiesManagement::ProcurementBuildingService, :count)
      end
    end

    context 'when procurement_building_service already exists' do
      it 'does not create a new one' do
        procurement_building.active = true
        procurement_building.service_codes = ['test']
        procurement_building.save
        procurement_building.service_codes = ['test']
        expect { procurement_building.save }.not_to change(FacilitiesManagement::ProcurementBuildingService, :count)
      end
    end

    context 'when procurement_building_service already exists but for a different service code' do
      it 'creates a new one and deletes the old one' do
        procurement_building.active = true
        procurement_building.service_codes = ['test']
        procurement_building.save
        procurement_building.service_codes = ['test1']
        procurement_building.save
        procurement_building.reload
        expect(procurement_building.procurement_building_services.first.code).to eq 'test1'
        expect(procurement_building.procurement_building_services.count).to eq 1
      end
    end
  end
end
