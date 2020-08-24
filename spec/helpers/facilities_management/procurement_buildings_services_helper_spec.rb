require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementBuildingsServicesHelper, type: :helper do
  describe '#service_standard_type' do
    let(:procurement_building_service) { create(:facilities_management_procurement_building_service, code: code, procurement_building: procurement_building) }
    let(:procurement_building) { create(:facilities_management_procurement_building, procurement: procurement) }
    let(:procurement) { create(:facilities_management_procurement) }

    context 'when the service is G.1 Routine Cleaning' do
      let(:code) { 'G.1' }

      it 'returns cleaning_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :cleaning_standards
      end
    end

    context 'when the service is G.3 Mobile Cleaning Services' do
      let(:code) { 'G.3' }

      it 'returns cleaning_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :cleaning_standards
      end
    end

    context 'when the service is G.4 Deep (Periodic) Cleaning' do
      let(:code) { 'G.4' }

      it 'returns cleaning_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :cleaning_standards
      end
    end

    context 'when the service is G.5 Cleaning of External Areas' do
      let(:code) { 'G.5' }

      it 'returns cleaning_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :cleaning_standards
      end
    end

    context 'when the service is C.7 Internal & External Building Fabric Maintenance' do
      let(:code) { 'C.7' }

      it 'returns building_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :building_standards
      end
    end

    context 'when the service is C.1 Mechanical and Electrical Engineering Maintenance' do
      let(:code) { 'C.1' }

      it 'returns ppm_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :ppm_standards
      end
    end

    context 'when the service is C.2 Ventilation and Air Conditioning System Maintenance' do
      let(:code) { 'C.2' }

      it 'returns ppm_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :ppm_standards
      end
    end

    context 'when the service is C.3 Environmental Cleaning Service' do
      let(:code) { 'C.3' }

      it 'returns ppm_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :ppm_standards
      end
    end

    context 'when the service is C.4 Fire Detection and Firefighting Systems Maintenance' do
      let(:code) { 'C.4' }

      it 'returns ppm_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :ppm_standards
      end
    end

    context 'when the service is C.6 Security, Access and Intruder Systems Maintenance' do
      let(:code) { 'C.6' }

      it 'returns ppm_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :ppm_standards
      end
    end

    context 'when the service is C.11 - Building Management System (BMS) Maintenance' do
      let(:code) { 'C.11' }

      it 'returns ppm_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :ppm_standards
      end
    end

    context 'when the service is C.12 Standby Power System Maintenance' do
      let(:code) { 'C.12' }

      it 'returns ppm_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :ppm_standards
      end
    end

    context 'when the service is C.13 - High Voltage (HV) and Switchgear Maintenance' do
      let(:code) { 'C.13' }

      it 'returns ppm_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :ppm_standards
      end
    end

    context 'when the service is C.5 Lifts, Hoists & Conveyance Systems Maintenance' do
      let(:code) { 'C.5' }

      it 'returns ppm_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :ppm_standards
      end
    end

    context 'when the service is C.14 - Catering Equipment Maintenance' do
      let(:code) { 'C.14' }

      it 'returns ppm_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :ppm_standards
      end
    end
  end
end
