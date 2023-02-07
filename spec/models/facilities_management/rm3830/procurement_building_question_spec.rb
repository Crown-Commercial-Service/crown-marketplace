require 'rails_helper'
RSpec.describe FacilitiesManagement::RM3830::ProcurementBuilding do
  subject(:procurement_building) { build(:facilities_management_rm3830_procurement_building, procurement: create(:facilities_management_rm3830_procurement), procurement_building_services: []) }

  describe '#validations' do
    context 'when active and service_codes equals k.2 and require questions are blank' do
      it 'is invalid' do
        procurement_building.active = true
        procurement_building.service_codes = ['K.2']
        procurement_building.save
        expect(procurement_building.valid?(:procurement_building_services)).to be false
      end
    end

    context 'when active and service_codes are empty' do
      it 'is valid' do
        procurement_building.active = true
        expect(procurement_building.valid?(:procurement_building_services)).to be true
      end
    end

    context 'when active and service_codes equals k.2 and required questions are answered' do
      it 'is valid' do
        procurement_building.active
        procurement_building.service_codes = ['K.2']
        procurement_building.save
        pbs = procurement_building.procurement_building_services.first
        pbs.tones_to_be_collected_and_removed = 90
        pbs.save
        expect(procurement_building.valid?(:procurement_building_services)).to be true
      end
    end

    context 'when active and service_codes equals k.2 as well as k.1 and required questions are not answered' do
      it 'is invalid' do
        procurement_building.active
        procurement_building.service_codes = ['K.2', 'K.1']
        procurement_building.save
        expect(procurement_building.valid?(:procurement_building_services)).to be false
      end
    end

    context 'when active and service_codes equals k.2 as well as k.1 and some required questions are not answered' do
      it 'is invalid' do
        procurement_building.active
        procurement_building.service_codes = ['K.1', 'K.2']
        procurement_building.save
        procurement_building.procurement_building_services.first.tones_to_be_collected_and_removed = 90
        procurement_building.procurement_building_services.first.save
        expect(procurement_building.valid?(:procurement_building_services)).to be false
      end
    end

    context 'when active and service_codes equals k.2 as well as k.1 and required questions are answered' do
      it 'is valid' do
        procurement_building.active
        procurement_building.service_codes = ['K.1', 'K.2']
        procurement_building.save
        procurement_building.procurement_building_services.first.no_of_consoles_to_be_serviced = 90
        procurement_building.procurement_building_services[1].tones_to_be_collected_and_removed = 90
        procurement_building.procurement_building_services.first.save
        procurement_building.procurement_building_services[1].save
        expect(procurement_building.valid?(:procurement_building_services)).to be true
      end
    end
  end
end
