require 'rails_helper'

RSpec.describe FacilitiesManagement::Beta::ProcurementBuildingsHelper, type: :helper do
  describe '#question_type' do
    context 'when using a ppm code' do
      it 'will return ppm_standards with C.1' do
        service = FacilitiesManagement::ProcurementBuildingService.new
        service.code = 'C.1'
        result = helper.question_type(service, :service_standard)
        expect(result).to eq 'ppm_standards'
      end
    end

    context 'when using a building code' do
      it 'will return building_standards with C.7' do
        service = FacilitiesManagement::ProcurementBuildingService.new
        service.code = 'C.7'
        result = helper.question_type(service, :service_standard)
        expect(result).to eq 'building_standards'
      end
    end

    context 'when using a cleaning code' do
      it 'will return cleaning_standards with G.1' do
        service = FacilitiesManagement::ProcurementBuildingService.new
        service.code = 'G.1'
        result = helper.question_type(service, :service_standard)
        expect(result).to eq 'cleaning_standards'
      end

      it 'will return cleaning_standards with G.12' do
        service = FacilitiesManagement::ProcurementBuildingService.new
        service.code = 'G.12'
        result = helper.question_type(service, :service_standard)
        expect(result).to eq 'cleaning_standards'
      end
    end

    context 'when using a volume code' do
      it 'will return volume with G.3' do
        service = FacilitiesManagement::ProcurementBuildingService.new
        service.code = 'G.3'
        result = helper.question_type(service, nil)
        expect(result).to eq 'volume'
      end
    end
  end
end
