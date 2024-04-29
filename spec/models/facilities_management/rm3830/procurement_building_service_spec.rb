require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::ProcurementBuildingService do
  subject(:procurement_building_service) { build(:facilities_management_rm3830_procurement_building_service, service_standard: nil, code: nil, procurement_building: create(:facilities_management_rm3830_procurement_building, procurement: create(:facilities_management_rm3830_procurement))) }

  describe '#validations' do
    context 'when code = C.1' do
      before { procurement_building_service.code = 'C.1' }

      it 'is valid if service_standard is present' do
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to be true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        expect(procurement_building_service.valid?(:ppm_standards)).to be false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        expect(procurement_building_service.valid?(:volume)).to be true
      end
    end

    context 'when code = C.2' do
      before { procurement_building_service.code = 'C.2' }

      it 'is valid if service_standard is present' do
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to be true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        expect(procurement_building_service.valid?(:ppm_standards)).to be false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        expect(procurement_building_service.valid?(:volume)).to be true
      end
    end

    context 'when code = C.3' do
      before { procurement_building_service.code = 'C.3' }

      it 'is valid if service_standard is present' do
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to be true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        expect(procurement_building_service.valid?(:ppm_standards)).to be false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        expect(procurement_building_service.valid?(:volume)).to be true
      end
    end

    context 'when code = C.4' do
      before { procurement_building_service.code = 'C.4' }

      it 'is valid if service_standard is present' do
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to be true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        expect(procurement_building_service.valid?(:ppm_standards)).to be false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        expect(procurement_building_service.valid?(:volume)).to be true
      end
    end

    context 'when code = C.5' do
      before { procurement_building_service.code = 'C.5' }

      it 'is valid if service_standard is present' do
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to be true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        expect(procurement_building_service.valid?(:ppm_standards)).to be false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        expect(procurement_building_service.valid?(:volume)).to be true
      end
    end

    context 'when code = C.6' do
      before { procurement_building_service.code = 'C.6' }

      it 'is valid if service_standard is present' do
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to be true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        expect(procurement_building_service.valid?(:ppm_standards)).to be false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        expect(procurement_building_service.valid?(:volume)).to be true
      end
    end

    context 'when code = C.11' do
      before { procurement_building_service.code = 'C.11' }

      it 'is valid if service_standard is present' do
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to be true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        expect(procurement_building_service.valid?(:ppm_standards)).to be false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        expect(procurement_building_service.valid?(:volume)).to be true
      end
    end

    context 'when code = C.12' do
      before { procurement_building_service.code = 'C.12' }

      it 'is valid if service_standard is present' do
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to be true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        expect(procurement_building_service.valid?(:ppm_standards)).to be false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        expect(procurement_building_service.valid?(:volume)).to be true
      end
    end

    context 'when code = C.13' do
      before { procurement_building_service.code = 'C.13' }

      it 'is valid if service_standard is present' do
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to be true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        expect(procurement_building_service.valid?(:ppm_standards)).to be false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        expect(procurement_building_service.valid?(:volume)).to be true
      end
    end

    context 'when code = C.14' do
      before { procurement_building_service.code = 'C.14' }

      it 'is valid if service_standard is present' do
        procurement_building_service.service_standard = 'A'
        expect(procurement_building_service.valid?(:ppm_standards)).to be true
      end

      it 'is not valid if service_standard is not present on ppm_standards context' do
        expect(procurement_building_service.valid?(:ppm_standards)).to be false
      end

      it 'does not validate if service_standards is not present and not on ppm_standards context' do
        expect(procurement_building_service.valid?(:volume)).to be true
      end
    end

    context 'when code = E.4' do
      before { procurement_building_service.code = 'E.4' }

      it 'validates no_of_appliances_for_testing grater than 0 if value is present' do
        procurement_building_service.no_of_appliances_for_testing = -1
        expect(procurement_building_service.valid?(:volume)).to be false
      end

      it 'is valid if no_of_appliances_for_testing is present and greater than 0' do
        procurement_building_service.no_of_appliances_for_testing = 2
        expect(procurement_building_service.valid?(:volume)).to be true
      end

      context 'when the no_of_appliances_for_testing if value is not present' do
        it 'is not valid' do
          expect(procurement_building_service.valid?(:volume)).to be false
        end

        it 'has the correct error message' do
          procurement_building_service.valid?(:volume)
          expect(procurement_building_service.errors[:no_of_appliances_for_testing].first).to eq 'Enter number of portable appliances'
        end
      end

      context 'when the no_of_appliances_for_testing is more than the max value' do
        before { procurement_building_service.no_of_appliances_for_testing = 10000000000 }

        it 'is not valid' do
          expect(procurement_building_service.valid?(:volume)).to be false
        end

        it 'has the correct error message' do
          procurement_building_service.valid?(:volume)
          expect(procurement_building_service.errors[:no_of_appliances_for_testing].first).to eq 'The number of portable appliances must be a whole number between 1 and 999,999,999'
        end
      end
    end

    context 'when code = G.1' do
      before { procurement_building_service.code = 'G.1' }

      it 'validates no_of_building_occupants grater than 0 if value is present' do
        procurement_building_service.no_of_building_occupants = -1
        expect(procurement_building_service.valid?(:volume)).to be false
      end

      it 'is valid if no_of_building_occupants is present and greater than 0' do
        procurement_building_service.no_of_building_occupants = 2
        expect(procurement_building_service.valid?(:volume)).to be true
      end

      context 'when the no_of_building_occupants if value is not present' do
        it 'is not valid' do
          expect(procurement_building_service.valid?(:volume)).to be false
        end

        it 'has the correct error message' do
          procurement_building_service.valid?(:volume)
          expect(procurement_building_service.errors[:no_of_building_occupants].first).to eq 'Enter number of building occupants'
        end
      end

      context 'when the no_of_building_occupants is more than the max value' do
        before { procurement_building_service.no_of_building_occupants = 10000000000 }

        it 'is not valid' do
          expect(procurement_building_service.valid?(:volume)).to be false
        end

        it 'has the correct error message' do
          procurement_building_service.valid?(:volume)
          expect(procurement_building_service.errors[:no_of_building_occupants].first).to eq 'The number of building occupants must be a whole number between 1 and 999,999,999'
        end
      end
    end

    context 'when code = G.3' do
      before { procurement_building_service.code = 'G.3' }

      it 'validates no_of_building_occupants grater than 0 if value is present' do
        procurement_building_service.no_of_building_occupants = -1
        expect(procurement_building_service.valid?(:volume)).to be false
      end

      it 'is valid if no_of_building_occupants is present and greater than 0' do
        procurement_building_service.no_of_building_occupants = 2
        expect(procurement_building_service.valid?(:volume)).to be true
      end

      context 'when the no_of_building_occupants if value is not present' do
        it 'is not valid' do
          expect(procurement_building_service.valid?(:volume)).to be false
        end

        it 'has the correct error message' do
          procurement_building_service.valid?(:volume)
          expect(procurement_building_service.errors[:no_of_building_occupants].first).to eq 'Enter number of building occupants'
        end
      end

      context 'when the no_of_building_occupants is more than the max value' do
        before { procurement_building_service.no_of_building_occupants = 10000000000 }

        it 'is not valid' do
          expect(procurement_building_service.valid?(:volume)).to be false
        end

        it 'has the correct error message' do
          procurement_building_service.valid?(:volume)
          expect(procurement_building_service.errors[:no_of_building_occupants].first).to eq 'The number of building occupants must be a whole number between 1 and 999,999,999'
        end
      end
    end

    context 'when code = K.1' do
      before { procurement_building_service.code = 'K.1' }

      it 'validates no_of_consoles_to_be_serviced grater than 0 if value is present' do
        procurement_building_service.no_of_consoles_to_be_serviced = -1
        expect(procurement_building_service.valid?(:volume)).to be false
      end

      it 'is valid if no_of_consoles_to_be_serviced is present and greater than 0' do
        procurement_building_service.no_of_consoles_to_be_serviced = 2
        expect(procurement_building_service.valid?(:volume)).to be true
      end

      context 'when the no_of_consoles_to_be_serviced if value is not present' do
        it 'is not valid' do
          expect(procurement_building_service.valid?(:volume)).to be false
        end

        it 'has the correct error message' do
          procurement_building_service.valid?(:volume)
          expect(procurement_building_service.errors[:no_of_consoles_to_be_serviced].first).to eq 'Enter number of consoles'
        end
      end

      context 'when the no_of_consoles_to_be_serviced is more than the max value' do
        before { procurement_building_service.no_of_consoles_to_be_serviced = 10000000000 }

        it 'is not valid' do
          expect(procurement_building_service.valid?(:volume)).to be false
        end

        it 'has the correct error message' do
          procurement_building_service.valid?(:volume)
          expect(procurement_building_service.errors[:no_of_consoles_to_be_serviced].first).to eq 'The number of consoles must be a whole number between 1 and 999,999,999'
        end
      end
    end

    context 'when code = K.2' do
      before { procurement_building_service.code = 'K.2' }

      it 'validates tones_to_be_collected_and_removed grater than 0 if value is present' do
        procurement_building_service.tones_to_be_collected_and_removed = -1
        expect(procurement_building_service.valid?(:volume)).to be false
      end

      it 'is valid if tones_to_be_collected_and_removed is present and greater than 0' do
        procurement_building_service.tones_to_be_collected_and_removed = 2
        expect(procurement_building_service.valid?(:volume)).to be true
      end

      context 'when the tones_to_be_collected_and_removed if value is not present' do
        it 'is not valid' do
          expect(procurement_building_service.valid?(:volume)).to be false
        end

        it 'has the correct error message' do
          procurement_building_service.valid?(:volume)
          expect(procurement_building_service.errors[:tones_to_be_collected_and_removed].first).to eq 'Enter number of tonnes'
        end
      end

      context 'when the tones_to_be_collected_and_removed is more than the max value' do
        before { procurement_building_service.tones_to_be_collected_and_removed = 10000000000 }

        it 'is not valid' do
          expect(procurement_building_service.valid?(:volume)).to be false
        end

        it 'has the correct error message' do
          procurement_building_service.valid?(:volume)
          expect(procurement_building_service.errors[:tones_to_be_collected_and_removed].first).to eq 'The number of tonnes must be a whole number between 1 and 999,999,999'
        end
      end
    end

    context 'when code = K.3' do
      before { procurement_building_service.code = 'K.3' }

      it 'validates tones_to_be_collected_and_removed grater than 0 if value is present' do
        procurement_building_service.tones_to_be_collected_and_removed = -1
        expect(procurement_building_service.valid?(:volume)).to be false
      end

      it 'is valid if tones_to_be_collected_and_removed is present and greater than 0' do
        procurement_building_service.tones_to_be_collected_and_removed = 2
        expect(procurement_building_service.valid?(:volume)).to be true
      end

      context 'when the tones_to_be_collected_and_removed if value is not present' do
        it 'is not valid' do
          expect(procurement_building_service.valid?(:volume)).to be false
        end

        it 'has the correct error message' do
          procurement_building_service.valid?(:volume)
          expect(procurement_building_service.errors[:tones_to_be_collected_and_removed].first).to eq 'Enter number of tonnes'
        end
      end

      context 'when the tones_to_be_collected_and_removed is more than the max value' do
        before { procurement_building_service.tones_to_be_collected_and_removed = 10000000000 }

        it 'is not valid' do
          expect(procurement_building_service.valid?(:volume)).to be false
        end

        it 'has the correct error message' do
          procurement_building_service.valid?(:volume)
          expect(procurement_building_service.errors[:tones_to_be_collected_and_removed].first).to eq 'The number of tonnes must be a whole number between 1 and 999,999,999'
        end
      end
    end

    context 'when code = K.7' do
      before { procurement_building_service.code = 'K.7' }

      it 'validates no_of_units_to_be_serviced grater than 0 if value is present' do
        procurement_building_service.no_of_units_to_be_serviced = -1
        expect(procurement_building_service.valid?(:volume)).to be false
      end

      it 'is valid if no_of_units_to_be_serviced is present and greater than 0' do
        procurement_building_service.no_of_units_to_be_serviced = 2
        expect(procurement_building_service.valid?(:volume)).to be true
      end

      context 'when the no_of_units_to_be_serviced if value is not present' do
        it 'is not valid' do
          expect(procurement_building_service.valid?(:volume)).to be false
        end

        it 'has the correct error message' do
          procurement_building_service.valid?(:volume)
          expect(procurement_building_service.errors[:no_of_units_to_be_serviced].first).to eq 'Enter number of units'
        end
      end

      context 'when the no_of_units_to_be_serviced is more than the max value' do
        before { procurement_building_service.no_of_units_to_be_serviced = 10000000000 }

        it 'is not valid' do
          expect(procurement_building_service.valid?(:volume)).to be false
        end

        it 'has the correct error message' do
          procurement_building_service.valid?(:volume)
          expect(procurement_building_service.errors[:no_of_units_to_be_serviced].first).to eq 'The number of units must be a whole number between 1 and 999,999,999'
        end
      end
    end

    context 'when code = K.4' do
      before { procurement_building_service.code = 'K.4' }

      it 'validates tones_to_be_collected_and_removed grater than 0 if value is present' do
        procurement_building_service.tones_to_be_collected_and_removed = -1
        expect(procurement_building_service.valid?(:volume)).to be false
      end

      it 'is valid if tones_to_be_collected_and_removed is present and greater than 0' do
        procurement_building_service.tones_to_be_collected_and_removed = 2
        expect(procurement_building_service.valid?(:volume)).to be true
      end

      context 'when the tones_to_be_collected_and_removed if value is not present' do
        it 'is not valid' do
          expect(procurement_building_service.valid?(:volume)).to be false
        end

        it 'has the correct error message' do
          procurement_building_service.valid?(:volume)
          expect(procurement_building_service.errors[:tones_to_be_collected_and_removed].first).to eq 'Enter number of tonnes'
        end
      end

      context 'when the tones_to_be_collected_and_removed is more than the max value' do
        before { procurement_building_service.tones_to_be_collected_and_removed = 10000000000 }

        it 'is not valid' do
          expect(procurement_building_service.valid?(:volume)).to be false
        end

        it 'has the correct error message' do
          procurement_building_service.valid?(:volume)
          expect(procurement_building_service.errors[:tones_to_be_collected_and_removed].first).to eq 'The number of tonnes must be a whole number between 1 and 999,999,999'
        end
      end
    end

    context 'when code = K.5' do
      before { procurement_building_service.code = 'K.5' }

      it 'validates tones_to_be_collected_and_removed grater than 0 if value is present' do
        procurement_building_service.tones_to_be_collected_and_removed = -1
        expect(procurement_building_service.valid?(:volume)).to be false
      end

      it 'is valid if tones_to_be_collected_and_removed is present and greater than 0' do
        procurement_building_service.tones_to_be_collected_and_removed = 2
        expect(procurement_building_service.valid?(:volume)).to be true
      end

      context 'when the tones_to_be_collected_and_removed if value is not present' do
        it 'is not valid' do
          expect(procurement_building_service.valid?(:volume)).to be false
        end

        it 'has the correct error message' do
          procurement_building_service.valid?(:volume)
          expect(procurement_building_service.errors[:tones_to_be_collected_and_removed].first).to eq 'Enter number of tonnes'
        end
      end

      context 'when the tones_to_be_collected_and_removed is more than the max value' do
        before { procurement_building_service.tones_to_be_collected_and_removed = 10000000000 }

        it 'is not valid' do
          expect(procurement_building_service.valid?(:volume)).to be false
        end

        it 'has the correct error message' do
          procurement_building_service.valid?(:volume)
          expect(procurement_building_service.errors[:tones_to_be_collected_and_removed].first).to eq 'The number of tonnes must be a whole number between 1 and 999,999,999'
        end
      end
    end

    context 'when code = K.6' do
      before { procurement_building_service.code = 'K.6' }

      it 'validates tones_to_be_collected_and_removed grater than 0 if value is present' do
        procurement_building_service.tones_to_be_collected_and_removed = -1
        expect(procurement_building_service.valid?(:volume)).to be false
      end

      it 'is valid if tones_to_be_collected_and_removed is present and greater than 0' do
        procurement_building_service.tones_to_be_collected_and_removed = 2
        expect(procurement_building_service.valid?(:volume)).to be true
      end

      context 'when the tones_to_be_collected_and_removed if value is not present' do
        it 'is not valid' do
          expect(procurement_building_service.valid?(:volume)).to be false
        end

        it 'has the correct error message' do
          procurement_building_service.valid?(:volume)
          expect(procurement_building_service.errors[:tones_to_be_collected_and_removed].first).to eq 'Enter number of tonnes'
        end
      end

      context 'when the tones_to_be_collected_and_removed is more than the max value' do
        before { procurement_building_service.tones_to_be_collected_and_removed = 10000000000 }

        it 'is not valid' do
          expect(procurement_building_service.valid?(:volume)).to be false
        end

        it 'has the correct error message' do
          procurement_building_service.valid?(:volume)
          expect(procurement_building_service.errors[:tones_to_be_collected_and_removed].first).to eq 'The number of tonnes must be a whole number between 1 and 999,999,999'
        end
      end
    end

    context 'when validating the lift data' do
      before do
        procurement_building_service.code = 'C.5'
      end

      context 'when lift_data is blank' do
        it 'validates to true for normal context' do
          expect(procurement_building_service.valid?).to be true
        end

        it 'validates to false when validating lift data' do
          expect(procurement_building_service.valid?(:lifts)).to be false
        end
      end

      context 'when lift_data is an empty collection' do
        it 'validates to false when validating lift data' do
          procurement_building_service.lifts = []
          expect(procurement_building_service.valid?(:lifts)).to be false
        end
      end

      context 'when lift_data has 100 elements' do
        it 'validates to false' do
          100.times do
            procurement_building_service.lifts.build(number_of_floors: 100)
          end

          expect(procurement_building_service.valid?(:lifts)).to be false
        end
      end

      context 'when lift_data has elements are zero or 100 in value' do
        it 'validates to false' do
          [0, 99, 3, 4, 5, 6, 7, 8, 9, 10].each do |number_of_floors|
            procurement_building_service.lifts.build(number_of_floors:)
          end

          expect(procurement_building_service.valid?(:lifts)).to be false
        end

        it 'has an error collection containing corresponding index positions' do
          [3, 300, 4, 0, 5, 6, 7, 8, 9, 10].each do |number_of_floors|
            procurement_building_service.lifts.build(number_of_floors:)
          end

          expect(procurement_building_service.valid?(:lifts)).to be false
          expect(procurement_building_service.errors[:'lifts[3].number_of_floors'].any?).to be true
        end
      end
    end
  end

  describe 'service status and validations' do
    context 'when code has exclusive validations' do
      before do
        procurement_building_service.code = 'G.1'
      end

      it 'is invalid when only occupancy collected is invalid' do
        procurement_building_service.service_standard = 'B'
        procurement_building_service.no_of_building_occupants = -1
        expect(procurement_building_service.valid?(:cleaning_standards)).to be true
        expect(procurement_building_service.valid?(:volume)).to be false
        expect(procurement_building_service.valid?(:all)).to be false
      end

      it 'volume will be invalid and all correctly invalid' do
        procurement_building_service.no_of_building_occupants = -1
        procurement_building_service.service_standard = 'B'
        expect(procurement_building_service.valid?(:volume)).to be false
        expect(procurement_building_service.valid?(:cleaning_standards)).to be true
        expect(procurement_building_service.valid?(:all)).to be false
      end

      it 'volume will be valid (correctly) and all correctly valid' do
        procurement_building_service.no_of_building_occupants = 9
        procurement_building_service.service_standard = 'B'
        expect(procurement_building_service.valid?(:cleaning_standards)).to be true
        expect(procurement_building_service.valid?(:volume)).to be true
        expect(procurement_building_service.valid?(:all)).to be true
      end

      it 'is invalid when only service_standard is blank' do
        procurement_building_service.service_standard = nil
        procurement_building_service.no_of_building_occupants = 65
        expect(procurement_building_service.valid?(:cleaning_standards)).to be false
        expect(procurement_building_service.valid?(:volume)).to be true
        expect(procurement_building_service.valid?(:all)).to be false
      end

      it 'is valid when tonnes and service_standard are not blank' do
        procurement_building_service.service_standard = 'B'
        procurement_building_service.no_of_building_occupants = 65
        expect(procurement_building_service.valid?(:cleaning_standards)).to be true
        expect(procurement_building_service.valid?(:volume)).to be true
        expect(procurement_building_service.valid?(:volume)).to be true
      end
    end

    context 'when code requires standard' do
      before do
        procurement_building_service.code = 'C.1'
      end

      it 'is invalid when service standard is not an option' do
        procurement_building_service.service_standard = 'D'
        expect(procurement_building_service.valid?(:ppm_standards)).to be false
        expect(procurement_building_service.valid?(:all)).to be false
      end

      it 'is valid' do
        procurement_building_service.service_standard = 'B'
        expect(procurement_building_service.valid?(:ppm_standards)).to be true
      end

      it 'is invalid when service_standard is blank' do
        procurement_building_service.service_standard = nil
        expect(procurement_building_service.valid?(:ppm_standards)).to be false
        expect(procurement_building_service.valid?(:all)).to be false
      end

      it 'has the correct error message' do
        procurement_building_service.service_standard = nil
        procurement_building_service.valid?(:ppm_standards)
        expect(procurement_building_service.errors[:service_standard].first).to eq 'Select the level of standard'
      end
    end

    context 'when code has multiple validations' do
      let(:lift_data) { [] }

      before do
        procurement_building_service.code = 'C.5'
        lift_data.each do |number_of_floors|
          procurement_building_service.lifts.build(number_of_floors:)
        end
      end

      it 'is invalid without lift data' do
        expect(procurement_building_service.valid?(:lifts)).to be false
        expect(procurement_building_service.valid?(:all)).to be false
      end

      context 'with just valid lift data' do
        let(:lift_data) { [1, 50] }

        it 'is valid' do
          expect(procurement_building_service.valid?(:lifts)).to be true
          expect(procurement_building_service.valid?(:ppm_standards)).to be false
          expect(procurement_building_service.valid?(:all)).to be false
        end
      end

      context 'with just invalid lift data' do
        let(:lift_data) { [1, 1001] }

        it 'service_status will show invalid' do
          expect(procurement_building_service.valid?(:lifts)).to be false
          expect(procurement_building_service.valid?(:ppm_standards)).to be false
          expect(procurement_building_service.valid?(:all)).to be false
        end
      end

      context 'with just service_standard data' do
        it 'is invalid' do
          procurement_building_service[:service_standard] = 'B'
          expect(procurement_building_service.valid?(:lifts)).to be false
          expect(procurement_building_service.valid?(:ppm_standards)).to be true
          expect(procurement_building_service.valid?(:all)).to be false
        end
      end

      context 'with both lift and service_standard data' do
        let(:lift_data) { [1, 50] }

        it 'is valid with both lift and service standard data' do
          procurement_building_service[:service_standard] = 'B'
          expect(procurement_building_service.valid?(:lifts)).to be true
          expect(procurement_building_service.valid?(:all)).to be true
        end
      end
    end
  end

  describe 'code lookups' do
    describe '#requires_volume?' do
      context 'when code is does not require volumn' do
        it 'is false when C.5' do
          procurement_building_service.code = 'C.5'
          expect(procurement_building_service.requires_volume?).to be false
        end
      end

      context 'when code does require volume' do
        it 'is be true' do
          procurement_building_service.code = 'E.4'
          expect(procurement_building_service.requires_volume?).to be true
        end
      end
    end

    describe '#requires_service_standard?' do
      context 'when code requires ppm standards' do
        it 'is true when C.5' do
          procurement_building_service.code = 'C.5'
          expect(procurement_building_service.requires_service_standard?).to be true
        end
      end

      context 'when code requires building standards' do
        it 'is true when C.7' do
          procurement_building_service.code = 'C.7'
          expect(procurement_building_service.requires_service_standard?).to be true
        end
      end

      context 'when code requires cleaning standards' do
        it 'is true when G.5' do
          procurement_building_service.code = 'G.5'
          expect(procurement_building_service.requires_service_standard?).to be true
        end
      end

      context "when code doesn't require a service standard" do
        it 'is false when K.6' do
          procurement_building_service.code = 'K.6'
          expect(procurement_building_service.requires_service_standard?).to be false
        end
      end
    end

    describe '#requires_external_area?' do
      context 'when a service requires an external area' do
        it 'is true' do
          procurement_building_service.code = 'G.5'
          expect(procurement_building_service.requires_external_area?).to be true
        end
      end

      context 'when a service does not require an external area' do
        it 'is false' do
          procurement_building_service.code = 'K.1'
          expect(procurement_building_service.requires_external_area?).to be false
        end
      end
    end
  end

  describe '#lift_data' do
    context 'when more than 99 lifts are added' do
      it 'is not valid' do
        100.times do
          procurement_building_service.lifts.build(number_of_floors: 100)
        end

        expect(procurement_building_service.valid?(:lifts)).to be false
      end
    end

    context 'when up to 99 lifts are added' do
      it 'is valid' do
        99.times do
          procurement_building_service.lifts.build(number_of_floors: 100)
        end

        expect(procurement_building_service.valid?(:lifts)).to be true
      end
    end
  end

  describe '#uval' do
    let(:code) { nil }
    let(:lift_data) { [] }
    let(:no_of_appliances_for_testing) { nil }
    let(:no_of_building_occupants) { nil }
    let(:no_of_consoles_to_be_serviced) { nil }
    let(:tones_to_be_collected_and_removed) { nil }
    let(:no_of_units_to_be_serviced) { nil }
    let(:service_hours) { nil }
    let(:procurement_building_service) do
      create(:facilities_management_rm3830_procurement_building_service,
             code: code,
             no_of_appliances_for_testing: no_of_appliances_for_testing,
             no_of_building_occupants: no_of_building_occupants,
             no_of_consoles_to_be_serviced: no_of_consoles_to_be_serviced,
             tones_to_be_collected_and_removed: tones_to_be_collected_and_removed,
             no_of_units_to_be_serviced: no_of_units_to_be_serviced,
             service_hours: service_hours,
             procurement_building: create(:facilities_management_rm3830_procurement_building_no_services,
                                          procurement: create(:facilities_management_rm3830_procurement_no_procurement_buildings)))
    end

    before do
      lift_data.each do |number_of_floors|
        procurement_building_service.lifts.create(number_of_floors:)
      end
    end

    context 'when service is C.5' do
      let(:code) { 'C.5' }
      let(:lift_data) { [5, 5, 2, 2] }

      it 'returns lift_data' do
        expect(procurement_building_service.uval).to eq lift_data.sum
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
      let(:size_of_external_area) { procurement_building_service.procurement_building.external_area }

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

      let(:service_hours) { 1820 }

      it 'returns total_hours_annually' do
        expect(procurement_building_service.uval).to eq service_hours
      end
    end

    context 'when C.1' do
      let(:code) { 'C.1' }

      it 'returns building GIA' do
        expect(procurement_building_service.uval).to eq 1002
      end
    end
  end

  describe '#service_hours' do
    before { procurement_building_service.detail_of_requirement = 'Some detail' }

    context 'when the service_hours is blank' do
      before { procurement_building_service.service_hours = nil }

      it 'is not valid' do
        expect(procurement_building_service.valid?(:service_hours)).to be false
      end

      it 'has the correct error message' do
        procurement_building_service.valid?(:service_hours)
        expect(procurement_building_service.errors[:service_hours].first).to eq 'Enter number of hours per year'
      end
    end

    context 'when the service_hours is zero' do
      before { procurement_building_service.service_hours = 0 }

      it 'is not valid' do
        expect(procurement_building_service.valid?(:service_hours)).to be false
      end

      it 'has the correct error message' do
        procurement_building_service.valid?(:service_hours)
        expect(procurement_building_service.errors[:service_hours].first).to eq 'Number of hours per year must be a whole number between 1 and 999,999,999'
      end
    end

    context 'when the service_hours is 1 billion' do
      before { procurement_building_service.service_hours = 1000000000 }

      it 'is not valid' do
        expect(procurement_building_service.valid?(:service_hours)).to be false
      end

      it 'has the correct error message' do
        procurement_building_service.valid?(:service_hours)
        expect(procurement_building_service.errors[:service_hours].first).to eq 'Number of hours per year must be a whole number between 1 and 999,999,999'
      end
    end

    context 'when the service_hours is not an interger' do
      before { procurement_building_service.service_hours = 506.78 }

      it 'is not valid' do
        expect(procurement_building_service.valid?(:service_hours)).to be false
      end

      it 'has the correct error message' do
        procurement_building_service.valid?(:service_hours)
        expect(procurement_building_service.errors[:service_hours].first).to eq 'Number of hours per year must be a whole number between 1 and 999,999,999'
      end
    end

    context 'when the service_hours is an integer within the range' do
      it 'is valid' do
        procurement_building_service.service_hours = rand(1..1000)
        expect(procurement_building_service.valid?(:service_hours)).to be true
      end
    end

    context 'when the service_hours is 1' do
      it 'is valid' do
        procurement_building_service.service_hours = 1
        expect(procurement_building_service.valid?(:service_hours)).to be true
      end
    end

    context 'when the service_hours is 999,999,999' do
      it 'is valid' do
        procurement_building_service.service_hours = 999999999
        expect(procurement_building_service.valid?(:service_hours)).to be true
      end
    end
  end

  describe '#detail_of_requirement' do
    before { procurement_building_service.service_hours = 806 }

    context 'when the detail_of_requirement is blank' do
      before { procurement_building_service.detail_of_requirement = nil }

      it 'is not valid' do
        expect(procurement_building_service.valid?(:service_hours)).to be false
      end

      it 'has the correct error message' do
        procurement_building_service.valid?(:service_hours)
        expect(procurement_building_service.errors[:detail_of_requirement].first).to eq 'Enter the detail of requirement'
      end
    end

    context 'when the detail_of_requirement is empty' do
      before { procurement_building_service.detail_of_requirement = '' }

      it 'is not valid' do
        expect(procurement_building_service.valid?(:service_hours)).to be false
      end

      it 'has the correct error message' do
        procurement_building_service.valid?(:service_hours)
        expect(procurement_building_service.errors[:detail_of_requirement].first).to eq 'Enter the detail of requirement'
      end
    end

    context 'when the detail_of_requirement is more than the max number of characters' do
      it 'is valid' do
        procurement_building_service.detail_of_requirement = 'a' * 501
        expect(procurement_building_service.valid?(:service_hours)).to be false
      end
    end

    context 'when the detail_of_requirement is only carriage return characters' do
      it 'is not valid' do
        procurement_building_service.detail_of_requirement = "\r\n" * 10
        expect(procurement_building_service.valid?(:service_hours)).to be false
      end
    end

    context 'when the detail_of_requirement is within the range of characters' do
      it 'is valid' do
        procurement_building_service.detail_of_requirement = 'This is the detail of the requirement'
        expect(procurement_building_service.valid?(:service_hours)).to be true
      end
    end

    context 'when the detail_of_requirement is within the range of with carriage return characters' do
      it 'is valid' do
        procurement_building_service.detail_of_requirement = ('a' * 490) + ("\r\n" * 10)
        expect(procurement_building_service.valid?(:service_hours)).to be true
      end
    end
  end

  describe '#required_volume_contexts' do
    let(:procurement_building_service) do
      create(:facilities_management_rm3830_procurement_building_service,
             code: code,
             procurement_building: create(:facilities_management_rm3830_procurement_building_no_services, procurement: create(:facilities_management_rm3830_procurement_no_procurement_buildings)))
    end

    context 'when the service does not have any required contexts' do
      let(:code) { 'O.1' }

      it 'returns an empty hash' do
        expect(procurement_building_service.required_volume_contexts).to eq({})
      end
    end

    context 'when the service does have one required context' do
      let(:code) { 'C.5' }

      it 'returns a hash with correct context' do
        expect(procurement_building_service.required_volume_contexts).to eq lifts: [:lift_data]
      end
    end

    context 'when the service requires gia' do
      let(:code) { 'C.1' }

      it 'returns a hash with correct context' do
        expect(procurement_building_service.required_volume_contexts).to eq gia: [:gia]
      end
    end

    context 'when the service requires external area' do
      let(:code) { 'G.5' }

      it 'returns a hash with correct context' do
        expect(procurement_building_service.required_volume_contexts).to eq external_area: [:external_area]
      end
    end

    context 'when the service requires a volume and gia' do
      let(:code) { 'G.3' }

      it 'returns a hash with correct context' do
        expect(procurement_building_service.required_volume_contexts).to eq(volume: [:no_of_building_occupants], gia: [:gia])
      end
    end
  end

  describe '#requires_unit_of_measure?' do
    before { procurement_building_service.code = code }

    context 'when the service requires only gia' do
      let(:code) { 'C.1' }

      it 'returns false' do
        expect(procurement_building_service.requires_unit_of_measure?).to be false
      end
    end

    context 'when the service requires external_area' do
      let(:code) { 'G.5' }

      it 'returns false' do
        expect(procurement_building_service.requires_unit_of_measure?).to be false
      end
    end

    context 'when the service requires lift_data' do
      let(:code) { 'C.5' }

      it 'returns false' do
        expect(procurement_building_service.requires_unit_of_measure?).to be true
      end
    end

    context 'when the service requires service_hours' do
      let(:code) { 'H.5' }

      it 'returns false' do
        expect(procurement_building_service.requires_unit_of_measure?).to be true
      end
    end

    context 'when the service requires no_of_appliances_for_testing' do
      let(:code) { 'E.4' }

      it 'returns false' do
        expect(procurement_building_service.requires_unit_of_measure?).to be true
      end
    end

    context 'when the service requires no_of_building_occupants' do
      let(:code) { 'G.3' }

      it 'returns false' do
        expect(procurement_building_service.requires_unit_of_measure?).to be true
      end
    end

    context 'when the service requires no_of_consoles_to_be_serviced' do
      let(:code) { 'K.1' }

      it 'returns false' do
        expect(procurement_building_service.requires_unit_of_measure?).to be true
      end
    end

    context 'when the service requires tones_to_be_collected_and_removed' do
      let(:code) { 'K.2' }

      it 'returns false' do
        expect(procurement_building_service.requires_unit_of_measure?).to be true
      end
    end

    context 'when the service requires no_of_units_to_be_serviced' do
      let(:code) { 'K.7' }

      it 'returns false' do
        expect(procurement_building_service.requires_unit_of_measure?).to be true
      end
    end

    context 'when the service does not require a unit of measure' do
      let(:code) { 'H.16' }

      it 'returns false' do
        expect(procurement_building_service.requires_unit_of_measure?).to be false
      end
    end
  end
end
