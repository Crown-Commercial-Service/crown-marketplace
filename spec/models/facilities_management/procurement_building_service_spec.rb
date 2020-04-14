require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementBuildingService, type: :model do
  subject(:procurement_building_service) { build(:facilities_management_procurement_building_service, service_standard: nil, code: nil, procurement_building: create(:facilities_management_procurement_building, procurement: create(:facilities_management_procurement))) }

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

      it 'will be invalid when only occupancy collected is invalid' do
        procurement_building_service.service_standard = 'B'
        procurement_building_service.no_of_building_occupants = -1
        expect(procurement_building_service.valid?(:cleaning_standards)).to eq true
        expect(procurement_building_service.valid?(:volume)).to eq false
        expect(procurement_building_service.valid?(:all)).to eq false
      end

      it 'volume will be invalid and all correctly invalid' do
        procurement_building_service.no_of_building_occupants = -1
        procurement_building_service.service_standard = 'B'
        expect(procurement_building_service.valid?(:volume)).to eq false
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
      end

      context 'with just lift data' do
        it 'will be valid with good data' do
          procurement_building_service[:lift_data] = %w[1 50]
          expect(procurement_building_service.valid?(:lifts)).to eq true
          expect(procurement_building_service.valid?(:ppm_standards)).to eq false
          expect(procurement_building_service.valid?(:all)).to eq false
        end

        it 'service_status will show invalid when lift_data invalid' do
          procurement_building_service[:lift_data] = %w[1 1001]
          service_status = procurement_building_service.services_status
          expect(service_status[:validity][:lifts].empty?).to eq false
          expect(service_status[:validity][:ppm_standards].empty?).to eq false
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
          expect(service_status[:validity][:lifts].empty?).to eq false
          expect(service_status[:validity][:ppm_standards].empty?).to eq true
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
          expect(service_status[:validity][:lifts].empty?).to eq true
          expect(service_status[:validity][:ppm_standards].empty?).to eq true
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

  describe '#validate_services' do
    context 'when empty' do
      it 'will be so' do
        procurement_building_service.code = 'C.5'
        procurement_building_service.lift_data = %w[1 2 3]
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.services_status[:validity][:lifts].empty?).to eq(true)
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
        expect(result[:contexts]).to include(:cleaning_standards)
        expect(result[:validity][:cleaning_standards].empty?).to eq(false)
      end
    end
  end

  # rubocop:disable RSpec/BeforeAfterAll
  describe '#service_hours' do
    let(:mock_ar_class) { build_mock_ar }
    let(:record) { mock_ar_class.create(service_hours: {}) }

    before(:all) do
      ActiveRecord::Base.connection.drop_table :pbs_mock if ActiveRecord::Base.connection.data_source_exists? 'pbs_mock'
      ActiveRecord::Base.connection.create_table :pbs_mock do |t|
        t.jsonb :service_hours, null: true
      end
    end

    after(:all) do
      ActiveRecord::Base.connection.drop_table :pbs_mock
    end

    def build_mock_ar
      Class.new(ApplicationRecord) do
        self.table_name = 'pbs_mock'
        serialize :service_hours, FacilitiesManagement::ServiceHours

        attr_accessor :id
      end
    end

    context 'when saving' do
      let(:sh) { FacilitiesManagement::ServiceHours.new }

      before do
        sh[:tuesday][:service_choice] = :all_day
        sh[:wednesday][:start_hour] = '10'
        sh[:wednesday][:start_minute] = '00'
        sh[:wednesday][:start_ampm] = 'am'
        sh[:wednesday][:end_hour] = '10'
        sh[:wednesday][:end_minute] = '00'
        sh[:wednesday][:end_ampm] = 'pm'
      end

      it 'will produce a hash' do
        record[:service_hours] = sh
        record.save
        result = ActiveRecord::Base.connection.execute('select service_hours from pbs_mock')
        expect(result).not_to eq nil
      end
    end
  end
  # rubocop:enable RSpec/BeforeAfterAll

  describe '#lift_data' do
    context 'when more than 99 lifts are added' do
      it 'will not be valid' do
        procurement_building_service.lift_data = Array.new(100, 10)
        expect(procurement_building_service.valid?(:lifts)).to be false
        procurement_building_service.lift_data = Array.new(rand(100..200), 10)
        expect(procurement_building_service.valid?(:lifts)).to be false
      end
    end

    context 'when up to 99 lifts are added' do
      it 'will be valid' do
        procurement_building_service.lift_data = Array.new(rand(1..98), 10)
        expect(procurement_building_service.valid?(:lifts)).to be true
        procurement_building_service.lift_data = Array.new(99, 10)
        expect(procurement_building_service.valid?(:lifts)).to be true
      end
    end
  end

  describe '#uval' do
    let(:code) { nil }
    let(:lift_data) { nil }
    let(:no_of_appliances_for_testing) { nil }
    let(:no_of_building_occupants) { nil }
    let(:size_of_external_area) { nil }
    let(:no_of_consoles_to_be_serviced) { nil }
    let(:tones_to_be_collected_and_removed) { nil }
    let(:no_of_units_to_be_serviced) { nil }
    let(:service_hours) { nil }
    let(:procurement_building_service) do
      create(:facilities_management_procurement_building_service,
             code: code,
             lift_data: lift_data,
             no_of_appliances_for_testing: no_of_appliances_for_testing,
             no_of_building_occupants: no_of_building_occupants,
             size_of_external_area: size_of_external_area,
             no_of_consoles_to_be_serviced: no_of_consoles_to_be_serviced,
             tones_to_be_collected_and_removed: tones_to_be_collected_and_removed,
             no_of_units_to_be_serviced: no_of_units_to_be_serviced,
             service_hours: service_hours,
             procurement_building: create(:facilities_management_procurement_building_no_services,
                                          procurement: create(:facilities_management_procurement_no_procurement_buildings)))
    end

    context 'when service is C.5' do
      let(:code) { 'C.5' }
      let(:lift_data) { %w[5 5 2 2] }

      it 'returns lift_data' do
        expect(procurement_building_service.uval).to eq lift_data.map(&:to_i).inject(&:+)
      end

      it 'does not return building GIA' do
        expect(procurement_building_service.uval).not_to eq 1002
      end
    end

    context 'when service is E.4' do
      let(:code) { 'E.4' }
      let(:no_of_appliances_for_testing) { 110 }

      it 'returns no_of_appliances_for_testing' do
        expect(procurement_building_service.uval).to eq no_of_appliances_for_testing
      end
    end

    context 'when service is G.1' do
      let(:code) { 'G.1' }
      let(:no_of_building_occupants) { 192 }

      it 'returns no_of_building_occupants' do
        expect(procurement_building_service.uval).to eq no_of_building_occupants
      end
    end

    context 'when service is G.5' do
      let(:code) { 'G.5' }
      let(:size_of_external_area) { 925 }

      it 'returns size_of_external_area' do
        expect(procurement_building_service.uval).to eq size_of_external_area
      end
    end

    context 'when service is K.1' do
      let(:code) { 'K.1' }
      let(:no_of_consoles_to_be_serviced) { 22 }

      it 'returns no_of_consoles_to_be_serviced' do
        expect(procurement_building_service.uval).to eq no_of_consoles_to_be_serviced
      end
    end

    context 'when service is K.2' do
      let(:code) { 'K.2' }
      let(:tones_to_be_collected_and_removed) { 22 }

      it 'returns tones_to_be_collected_and_removed' do
        expect(procurement_building_service.uval).to eq tones_to_be_collected_and_removed
      end
    end

    context 'when K.7' do
      let(:code) { 'K.7' }
      let(:no_of_units_to_be_serviced) { 45 }

      it 'returns no_of_units_to_be_serviced' do
        expect(procurement_building_service.uval).to eq no_of_units_to_be_serviced
      end
    end

    context 'when J.6' do
      let(:code) { 'J.6' }

      let(:service_hours) { { "monday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "tuesday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "wednesday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "thursday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "friday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "saturday": { "service_choice": 'not_required', "start_hour": '', "start_minute": '', "start_ampm": 'AM', "end_hour": '', "end_minute": '', "end_ampm": 'AM', "uom": 0.0 }, "sunday": { "service_choice": 'not_required', "start_hour": '', "start_minute": '', "start_ampm": 'AM', "end_hour": '', "end_minute": '', "end_ampm": 'AM', "uom": 0.0 }, "uom": 0 } }

      it 'returns total_hours_annually' do
        expect(procurement_building_service.uval).to eq 1820
      end
    end

    context 'when C.1' do
      let(:code) { 'C.1' }

      it 'returns building GIA' do
        expect(procurement_building_service.uval).to eq 1002
      end
    end
  end
end
