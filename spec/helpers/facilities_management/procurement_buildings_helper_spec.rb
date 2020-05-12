require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementBuildingsHelper, type: :helper do
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
      it 'will return cleaning_standards with G.3' do
        service = FacilitiesManagement::ProcurementBuildingService.new
        service.code = 'G.3'
        result = helper.question_type(service, :service_standard)
        expect(result).to eq 'cleaning_standards'
      end
      it 'will return cleaning_standards with G.4' do
        service = FacilitiesManagement::ProcurementBuildingService.new
        service.code = 'G.4'
        result = helper.question_type(service, :service_standard)
        expect(result).to eq 'cleaning_standards'
      end
      it 'will return cleaning_standards with G.5' do
        service = FacilitiesManagement::ProcurementBuildingService.new
        service.code = 'G.5'
        result = helper.question_type(service, :service_standard)
        expect(result).to eq 'cleaning_standards'
      end

      it 'will not return cleaning_standards with G.2' do
        service = FacilitiesManagement::ProcurementBuildingService.new
        service.code = 'G.2'
        result = helper.question_type(service, :service_standard)
        expect(result).to eq nil
      end

      it 'will not return cleaning_standards with G.6' do
        service = FacilitiesManagement::ProcurementBuildingService.new
        service.code = 'G.6'
        result = helper.question_type(service, :service_standard)
        expect(result).to eq nil
      end

      it 'will not return cleaning_standards with G.7' do
        service = FacilitiesManagement::ProcurementBuildingService.new
        service.code = 'G.7'
        result = helper.question_type(service, :service_standard)
        expect(result).to eq nil
      end

      it 'will not return cleaning_standards with G.8' do
        service = FacilitiesManagement::ProcurementBuildingService.new
        service.code = 'G.8'
        result = helper.question_type(service, :service_standard)
        expect(result).to eq nil
      end

      it 'will not return cleaning_standards with G.9' do
        service = FacilitiesManagement::ProcurementBuildingService.new
        service.code = 'G.9'
        result = helper.question_type(service, :service_standard)
        expect(result).to eq nil
      end

      it 'will not return cleaning_standards with G.10' do
        service = FacilitiesManagement::ProcurementBuildingService.new
        service.code = 'G.10'
        result = helper.question_type(service, :service_standard)
        expect(result).to eq nil
      end

      it 'will not return cleaning_standards with G.11' do
        service = FacilitiesManagement::ProcurementBuildingService.new
        service.code = 'G.11'
        result = helper.question_type(service, :service_standard)
        expect(result).to eq nil
      end

      it 'will not return cleaning_standards with G.12' do
        service = FacilitiesManagement::ProcurementBuildingService.new
        service.code = 'G.12'
        result = helper.question_type(service, :service_standard)
        expect(result).to eq nil
      end

      it 'will not return cleaning_standards with G.13' do
        service = FacilitiesManagement::ProcurementBuildingService.new
        service.code = 'G.13'
        result = helper.question_type(service, :service_standard)
        expect(result).to eq nil
      end

      it 'will not return cleaning_standards with G.14' do
        service = FacilitiesManagement::ProcurementBuildingService.new
        service.code = 'G.14'
        result = helper.question_type(service, :service_standard)
        expect(result).to eq nil
      end

      it 'will not return cleaning_standards with G.15' do
        service = FacilitiesManagement::ProcurementBuildingService.new
        service.code = 'G.15'
        result = helper.question_type(service, :service_standard)
        expect(result).to eq nil
      end

      it 'will not return cleaning_standards with G.16' do
        service = FacilitiesManagement::ProcurementBuildingService.new
        service.code = 'G.16'
        result = helper.question_type(service, :service_standard)
        expect(result).to eq nil
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
