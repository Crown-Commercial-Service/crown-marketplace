require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementBuildingService, type: :model do
  subject(:procurement_building_service) { build(:facilities_management_procurement_building_service, procurement_building: create(:facilities_management_procurement_building, procurement: create(:facilities_management_procurement))) }

  describe '#validations' do
    context 'when code = C.1' do
      it 'is valid if service_standard is present' do
        procurement_building_service.code = 'C.1'
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        procurement_building_service.code = 'C.1'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        procurement_building_service.code = 'C.1'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = C.2' do
      it 'is valid if service_standard is present' do
        procurement_building_service.code = 'C.2'
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        procurement_building_service.code = 'C.2'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        procurement_building_service.code = 'C.2'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = C.3' do
      it 'is valid if service_standard is present' do
        procurement_building_service.code = 'C.3'
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        procurement_building_service.code = 'C.3'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        procurement_building_service.code = 'C.3'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = C.4' do
      it 'is valid if service_standard is present' do
        procurement_building_service.code = 'C.4'
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        procurement_building_service.code = 'C.4'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        procurement_building_service.code = 'C.4'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = C.5' do
      it 'is valid if service_standard is present' do
        procurement_building_service.code = 'C.5'
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        procurement_building_service.code = 'C.5'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        procurement_building_service.code = 'C.5'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = C.6' do
      it 'is valid if service_standard is present' do
        procurement_building_service.code = 'C.6'
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        procurement_building_service.code = 'C.6'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        procurement_building_service.code = 'C.6'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = C.11' do
      it 'is valid if service_standard is present' do
        procurement_building_service.code = 'C.11'
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        procurement_building_service.code = 'C.11'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        procurement_building_service.code = 'C.11'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = C.12' do
      it 'is valid if service_standard is present' do
        procurement_building_service.code = 'C.12'
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        procurement_building_service.code = 'C.12'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        procurement_building_service.code = 'C.12'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = C.13' do
      it 'is valid if service_standard is present' do
        procurement_building_service.code = 'C.13'
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        procurement_building_service.code = 'C.13'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        procurement_building_service.code = 'C.13'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = C.14' do
      it 'is valid if service_standard is present' do
        procurement_building_service.code = 'C.14'
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        procurement_building_service.code = 'C.14'
        expect(procurement_building_service.valid?(:ppm_standards)).to eq false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        procurement_building_service.code = 'C.14'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = E.4' do
      it 'validates no_of_appliances_for_testing grater than 0 if value is present' do
        procurement_building_service.code = 'E.4'
        procurement_building_service.no_of_appliances_for_testing = -1
        expect(procurement_building_service.valid?(:volume)).to eq false
      end

      it 'does not validate no_of_appliances_for_testing if value is not present' do
        procurement_building_service.code = 'E.4'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end

      it 'is valid if no_of_appliances_for_testing is present and greater than 0' do
        procurement_building_service.code = 'E.4'
        procurement_building_service.no_of_appliances_for_testing = 2
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = G.1' do
      it 'validates no_of_building_occupants grater than 0 if value is present' do
        procurement_building_service.code = 'G.1'
        procurement_building_service.no_of_building_occupants = -1
        expect(procurement_building_service.valid?(:volume)).to eq false
      end

      it 'does not validate no_of_building_occupants if value is not present' do
        procurement_building_service.code = 'G.1'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end

      it 'is valid if no_of_building_occupants is present and greater than 0' do
        procurement_building_service.code = 'G.1'
        procurement_building_service.no_of_building_occupants = 2
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = G.3' do
      it 'validates no_of_building_occupants grater than 0 if value is present' do
        procurement_building_service.code = 'G.3'
        procurement_building_service.no_of_building_occupants = -1
        expect(procurement_building_service.valid?(:volume)).to eq false
      end

      it 'does not validate no_of_building_occupants if value is not present' do
        procurement_building_service.code = 'G.3'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end

      it 'is valid if no_of_building_occupants is present and greater than 0' do
        procurement_building_service.code = 'G.3'
        procurement_building_service.no_of_building_occupants = 2
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = G.5' do
      it 'validates size_of_external_area grater than 0 if value is present' do
        procurement_building_service.code = 'G.5'
        procurement_building_service.size_of_external_area = -1
        expect(procurement_building_service.valid?(:volume)).to eq false
      end

      it 'does not validate size_of_external_area if value is not present' do
        procurement_building_service.code = 'G.5'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end

      it 'is valid if size_of_external_area is present and greater than 0' do
        procurement_building_service.code = 'G.5'
        procurement_building_service.size_of_external_area = 2
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = K.1' do
      it 'validates no_of_consoles_to_be_serviced grater than 0 if value is present' do
        procurement_building_service.code = 'K.1'
        procurement_building_service.no_of_consoles_to_be_serviced = -1
        expect(procurement_building_service.valid?(:volume)).to eq false
      end

      it 'does not validate no_of_consoles_to_be_serviced if value is not present' do
        procurement_building_service.code = 'K.1'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end

      it 'is valid if no_of_consoles_to_be_serviced is present and greater than 0' do
        procurement_building_service.code = 'K.1'
        procurement_building_service.no_of_consoles_to_be_serviced = 2
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = K.2' do
      it 'validates tones_to_be_collected_and_removed grater than 0 if value is present' do
        procurement_building_service.code = 'K.2'
        procurement_building_service.tones_to_be_collected_and_removed = -1
        expect(procurement_building_service.valid?(:volume)).to eq false
      end

      it 'does not validate tones_to_be_collected_and_removed if value is not present' do
        procurement_building_service.code = 'K.2'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end

      it 'is valid if tones_to_be_collected_and_removed is present and greater than 0' do
        procurement_building_service.code = 'K.2'
        procurement_building_service.tones_to_be_collected_and_removed = 2
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = K.3' do
      it 'validates tones_to_be_collected_and_removed grater than 0 if value is present' do
        procurement_building_service.code = 'K.3'
        procurement_building_service.tones_to_be_collected_and_removed = -1
        expect(procurement_building_service.valid?(:volume)).to eq false
      end

      it 'does not validate tones_to_be_collected_and_removed if value is not present' do
        procurement_building_service.code = 'K.3'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end

      it 'is valid if tones_to_be_collected_and_removed is present and greater than 0' do
        procurement_building_service.code = 'K.3'
        procurement_building_service.tones_to_be_collected_and_removed = 2
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = K.7' do
      it 'validates no_of_units_to_be_serviced grater than 0 if value is present' do
        procurement_building_service.code = 'K.7'
        procurement_building_service.no_of_units_to_be_serviced = -1
        expect(procurement_building_service.valid?(:volume)).to eq false
      end

      it 'does not validate no_of_units_to_be_serviced if value is not present' do
        procurement_building_service.code = 'K.7'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end

      it 'is valid if no_of_units_to_be_serviced is present and greater than 0' do
        procurement_building_service.code = 'K.7'
        procurement_building_service.no_of_units_to_be_serviced = 2
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = K.4' do
      it 'validates tones_to_be_collected_and_removed grater than 0 if value is present' do
        procurement_building_service.code = 'K.4'
        procurement_building_service.tones_to_be_collected_and_removed = -1
        expect(procurement_building_service.valid?(:volume)).to eq false
      end

      it 'does not validate tones_to_be_collected_and_removed if value is not present' do
        procurement_building_service.code = 'K.4'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end

      it 'is valid if tones_to_be_collected_and_removed is present and greater than 0' do
        procurement_building_service.code = 'K.4'
        procurement_building_service.tones_to_be_collected_and_removed = 2
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = K.5' do
      it 'validates tones_to_be_collected_and_removed grater than 0 if value is present' do
        procurement_building_service.code = 'K.5'
        procurement_building_service.tones_to_be_collected_and_removed = -1
        expect(procurement_building_service.valid?(:volume)).to eq false
      end

      it 'does not validate tones_to_be_collected_and_removed if value is not present' do
        procurement_building_service.code = 'K.5'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end

      it 'is valid if tones_to_be_collected_and_removed is present and greater than 0' do
        procurement_building_service.code = 'K.5'
        procurement_building_service.tones_to_be_collected_and_removed = 2
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = K.6' do
      it 'validates tones_to_be_collected_and_removed greater than 0 if value is present' do
        procurement_building_service.code = 'K.6'
        procurement_building_service.tones_to_be_collected_and_removed = -1
        expect(procurement_building_service.valid?(:volume)).to eq false
      end

      it 'does not validate tones_to_be_collected_and_removed if value is not present' do
        procurement_building_service.code = 'K.6'
        expect(procurement_building_service.valid?(:volume)).to eq true
      end

      it 'is valid if tones_to_be_collected_and_removed is present and greater than 0' do
        procurement_building_service.code = 'K.6'
        procurement_building_service.tones_to_be_collected_and_removed = 2
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code = C.5' do
      context 'when lift_data is blank' do
        it 'validates to true for normal context' do
          procurement_building_service.code = 'C.5'
          expect(procurement_building_service.valid?).to eq true
        end

        it 'validates to false when validating lift data' do
          procurement_building_service.code = 'C.5'
          expect(procurement_building_service.valid?(:lifts)).to eq false
        end
      end

      context 'when lift_data is an empty collection' do
        it 'validates to false when validating lift data' do
          procurement_building_service.code = 'C.5'
          procurement_building_service.lift_data = []
          expect(procurement_building_service.valid?(:lifts)).to eq false
        end
      end

      context 'when lift_data has 1001 elements' do
        it 'validates to false' do
          procurement_building_service.code = 'C.5'
          procurement_building_service.lift_data = [*0..1001]
          expect(procurement_building_service.valid?(:lifts)).to eq false
        end
      end

      context 'when lift_data has elements are zero or 100 in value' do
        it 'validates to false' do
          procurement_building_service.code = 'C.5'
          procurement_building_service.lift_data = [0, 99, 3, 4, 5, 6, 7, 8, 9, 10]
          expect(procurement_building_service.valid?(:lifts)).to eq false
        end

        it 'has an error collection containing corresponding index positions' do
          procurement_building_service.code = 'C.5'
          procurement_building_service.lift_data = [0, 3, 300, 4, 5, 6, 7, 8, 9, 10]
          expect(procurement_building_service.valid?(:lifts)).to eq false
          expect(procurement_building_service.errors.details[:lift_data].find_index { |item| item[:position] == 0 }.present?).to eq true
        end
      end
    end
  end

  describe 'service status and validations' do
    context 'when code has exclusive validations' do
      before do
        procurement_building_service.code = 'G.1'
      end

      it 'will be invalid when only occupancy collected is blank' do
        procurement_building_service.service_standard = 'B'
        procurement_building_service.no_of_building_occupants = nil
        expect(procurement_building_service.valid?(:cleaning_standards)).to eq true
        expect(procurement_building_service.valid?(:volume)).to eq true
        expect(procurement_building_service.valid?(:all)).to eq false
      end

      it 'volume will be valid (incorrectly) and all correctly invalid' do
        procurement_building_service.no_of_building_occupants = nil
        procurement_building_service.service_standard = 'B'
        expect(procurement_building_service.valid?(:volume)).to eq true # this is incorrect
        expect(procurement_building_service.valid?(:cleaning_standards)).to eq true
        expect(procurement_building_service.valid?(:all)).to eq false
      end

      it 'volume will be valid (correctly) and all correctly valid' do
        procurement_building_service.no_of_building_occupants = 9
        procurement_building_service.service_standard = 'B'
        expect(procurement_building_service.valid?(:cleaning_standards)).to eq true
        expect(procurement_building_service.valid?(:volume)).to eq true
        expect(procurement_building_service.valid?(:all)).to eq true
      end

      it 'will be invalid when only service_standard is blank' do
        procurement_building_service.service_standard = nil
        procurement_building_service.no_of_building_occupants = 65
        expect(procurement_building_service.valid?(:cleaning_standards)).to eq false
        expect(procurement_building_service.valid?(:volume)).to eq true
        expect(procurement_building_service.valid?(:all)).to eq false
      end

      it 'will be valid when tonnes and service_standard are not blank' do
        procurement_building_service.service_standard = 'B'
        procurement_building_service.no_of_building_occupants = 65
        expect(procurement_building_service.valid?(:cleaning_standards)).to eq true
        expect(procurement_building_service.valid?(:volume)).to eq true
        expect(procurement_building_service.valid?(:volume)).to eq true
      end
    end

    context 'when code has multiple validations' do
      before do
        procurement_building_service.code = 'C.5'
      end

      it 'will be invalid without lift data' do
        expect(procurement_building_service.valid?(:lifts)).to eq false
        expect(procurement_building_service.valid?(:all)).to eq false
        service_status = procurement_building_service.services_status
        expect(service_status.include?(procurement_building_service.code.to_sym)).to eq true
      end

      context 'with just lift data' do
        it 'will be valid with good data' do
          procurement_building_service[:lift_data] = %w[1 50]
          expect(procurement_building_service.valid?(:lifts)).to eq true
          expect(procurement_building_service.valid?(:ppm_standards)).to eq false
          expect(procurement_building_service.valid?(:all)).to eq false
        end

        it 'service_status will showing invalid' do
          procurement_building_service[:lift_data] = %w[1 1001]
          service_status = procurement_building_service.services_status
          expect(service_status[procurement_building_service.code.to_sym].dig(:lifts)).to eq false
          expect(service_status[procurement_building_service.code.to_sym].dig(:ppm_standards)).to eq false
        end
      end

      context 'with just service_standard data' do
        it 'will be invalid' do
          procurement_building_service[:service_standard] = 'B'
          expect(procurement_building_service.valid?(:lifts)).to eq false
          expect(procurement_building_service.valid?(:ppm_standards)).to eq true
          expect(procurement_building_service.valid?(:all)).to eq false
        end

        it 'service status data will show it' do
          procurement_building_service[:service_standard] = 'B'
          service_status = procurement_building_service.services_status
          expect(service_status[procurement_building_service.code.to_sym].dig(:lifts)).to eq false
          expect(service_status[procurement_building_service.code.to_sym].dig(:ppm_standards)).to eq true
        end
      end

      context 'with both lift and service_standard data' do
        it 'will be valid with both lift and service standard data' do
          procurement_building_service[:service_standard] = 'B'
          procurement_building_service[:lift_data] = %w[1 50]
          expect(procurement_building_service.valid?(:lifts)).to eq true
          expect(procurement_building_service.valid?(:all)).to eq true
        end

        it 'service_status will indicate validity' do
          procurement_building_service[:service_standard] = 'B'
          procurement_building_service[:lift_data] = %w[1 50]
          service_status = procurement_building_service.services_status
          expect(service_status.include?(procurement_building_service.code.to_sym)).to eq true
          expect(service_status[procurement_building_service.code.to_sym].dig(:lifts)).to eq true
          expect(service_status[procurement_building_service.code.to_sym].dig(:ppm_standards)).to eq true
        end
      end
    end
  end

  describe 'code lookups' do
    describe '#requires_volume?' do
      context 'when code is does not require volumn' do
        it 'will be false when C.5' do
          procurement_building_service.code = 'C.5'
          expect(procurement_building_service.requires_volume?).to eq false
        end
      end

      context 'when code does require volume' do
        it 'will be be true' do
          procurement_building_service.code = 'E.4'
          expect(procurement_building_service.requires_volume?).to eq true
        end
      end
    end

    describe '#requires_ppm_standards?' do
      context 'when code requires ppm standards' do
        it 'will be true when C.5' do
          procurement_building_service.code = 'C.5'
          expect(procurement_building_service.requires_ppm_standards?).to eq true
        end
      end

      context 'when code doesn\'t require ppm standards' do
        it 'will be false when K.6' do
          procurement_building_service.code = 'K.6'
          expect(procurement_building_service.requires_ppm_standards?).to eq false
        end
      end
    end

    describe '#requires_building_standards?' do
      context 'when code requires building standards' do
        it 'will be true when C.7' do
          procurement_building_service.code = 'C.7'
          expect(procurement_building_service.requires_building_standards?).to eq true
        end
      end

      context 'when code doesn\'t require building standards' do
        it 'will be false when K.1' do
          procurement_building_service.code = 'K.1'
          expect(procurement_building_service.requires_building_standards?).to eq false
        end
      end
    end

    describe '#requires_cleaning_standards?' do
      context 'when code requires cleaning standards' do
        it 'will be true when G.5' do
          procurement_building_service.code = 'G.5'
          expect(procurement_building_service.requires_cleaning_standards?).to eq true
        end
      end

      context 'when code doesn\'t require cleaning standards' do
        it 'will be false when K.6' do
          procurement_building_service.code = 'K.6'
          expect(procurement_building_service.requires_cleaning_standards?).to eq false
        end
      end
    end
  end

  describe '#services_status' do
    context 'when analysing an empty service record' do
      it 'will return a hash indicating na/false' do
        expect(procurement_building_service.services_status).to include(:context)
        expect(procurement_building_service.services_status[:context]).to eq :na
      end

      it 'will return a hash indicating na/false when the code isn\'t initialised' do
        procurement_building_service.code = nil
        expect(procurement_building_service.services_status).to include(:context)
        expect(procurement_building_service.services_status[:context]).to eq :na
      end

      it 'will return a hash indicating unknown/false when the code isn\'t valid' do
        procurement_building_service.code = 'bad.code'
        expect(procurement_building_service.services_status).to include(:context)
        expect(procurement_building_service.services_status[:context]).to eq :unknown
      end
    end

    context 'when analysing a service record with a valid code' do
      it 'will return a hash with the correct contexts and false for G.1' do
        procurement_building_service.code = 'G.1'
        result = procurement_building_service.services_status
        expect(result[procurement_building_service[:code].to_sym]).to include(:cleaning_standards)
        expect(result[procurement_building_service[:code].to_sym][:cleaning_standards]).to eq(false)
      end
    end
  end
end
