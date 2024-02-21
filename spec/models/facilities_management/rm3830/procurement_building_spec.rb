require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::ProcurementBuilding do
  subject(:procurement_building) { build(:facilities_management_rm3830_procurement_building, procurement: create(:facilities_management_rm3830_procurement), procurement_building_services: []) }

  describe 'verify active scope works' do
    context 'when not active exclude' do
      it 'is active' do
        procurement_building.active = false
        procurement_building.save
        expect(described_class.active.count).to eq 1
      end

      it 'is not active' do
        procurement_building.active = true
        procurement_building.save
        expect(described_class.active.count).to eq 2
      end
    end
  end

  describe '#validations' do
    context 'when inactive and service_codes empty' do
      it 'is valid' do
        procurement_building.active = false
        procurement_building.service_codes = []
        expect(procurement_building.valid?(:buildings_and_services)).to be true
      end
    end

    context 'when inactive and service_codes not empty' do
      it 'is valid' do
        procurement_building.active = false
        procurement_building.service_codes = ['test']
        expect(procurement_building.valid?(:buildings_and_services)).to be true
      end
    end

    context 'when active and service_codes empty' do
      it 'is invalid' do
        procurement_building.active = true
        procurement_building.service_codes = []
        expect(procurement_building.valid?(:buildings_and_services)).to be false
      end
    end

    context 'when active and service_codes not empty' do
      it 'is valid' do
        procurement_building.active = true
        procurement_building.service_codes = ['test']
        expect(procurement_building.valid?(:buildings_and_services)).to be true
      end
    end
  end

  describe 'area completeness' do
    before do
      procurement_building.procurement.update(aasm_state: 'detailed_search')
      procurement_building.procurement_building_services = [build(:facilities_management_rm3830_procurement_building_service, code: service_code, service_standard: 'A', procurement_building: procurement_building)]
      procurement_building.building = build(:facilities_management_building, gia:, external_area:)
      procurement_building.service_codes = [service_code]
      procurement_building.save
    end

    context 'when it has a service that requires GIA' do
      let(:service_code) { 'G.1' }
      let(:external_area) { 1000 }

      context 'when the building does not have it' do
        let(:gia) { 0 }

        it 'is incomplete' do
          expect(procurement_building.internal_area_incomplete?).to be true
        end
      end

      context 'when the building does have it' do
        let(:gia) { 1000 }

        it 'is not incomplete' do
          expect(procurement_building.internal_area_incomplete?).to be false
        end
      end
    end

    context 'when it has a service that requires External area' do
      let(:service_code) { 'G.5' }
      let(:gia) { 1000 }

      context 'when the building does not have it' do
        let(:external_area) { 0 }

        it 'is incomplete' do
          expect(procurement_building.external_area_incomplete?).to be true
        end
      end

      context 'when the building does have it' do
        let(:external_area) { 1000 }

        it 'is not incomplete' do
          expect(procurement_building.external_area_incomplete?).to be false
        end
      end
    end
  end

  describe 'update_procurement_building_services' do
    context 'when no procurement_building_services exists' do
      it 'creates a new procurement_building_service' do
        procurement_building.active = true
        procurement_building.service_codes = ['test']
        expect { procurement_building.save }.to change(FacilitiesManagement::RM3830::ProcurementBuildingService, :count)
      end
    end

    context 'when procurement_building_service already exists' do
      it 'does not create a new one' do
        procurement_building.active = true
        procurement_building.service_codes = ['test']
        procurement_building.save
        procurement_building.service_codes = ['test']
        expect { procurement_building.save }.not_to change(FacilitiesManagement::RM3830::ProcurementBuildingService, :count)
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

  describe 'validation for special service choices' do
    before { procurement_building.active = true }

    context 'when the only service code selected is O.1' do
      before { procurement_building.service_codes = ['O.1'] }

      it 'is not valid' do
        expect(procurement_building.valid?(:buildings_and_services)).to be false
      end

      it 'has the correct error message' do
        procurement_building.valid?(:buildings_and_services)
        expect(procurement_building.errors[:service_codes].first).to eq "You must select another service to include 'Management of billable works'"
      end

      context 'when another service is included as well' do
        before { procurement_building.service_codes << 'C.1' }

        it 'is valid' do
          expect(procurement_building.valid?(:buildings_and_services)).to be true
        end
      end
    end

    context 'when the only service code selected is N.1' do
      before { procurement_building.service_codes = ['N.1'] }

      it 'is not valid' do
        expect(procurement_building.valid?(:buildings_and_services)).to be false
      end

      it 'has the correct error message' do
        procurement_building.valid?(:buildings_and_services)
        expect(procurement_building.errors[:service_codes].first).to eq "You must select another service to include 'Helpdesk services'"
      end

      context 'when another service is included as well' do
        before { procurement_building.service_codes << 'C.1' }

        it 'is valid' do
          expect(procurement_building.valid?(:buildings_and_services)).to be true
        end
      end
    end

    context 'when the only service code selected is M.1' do
      before { procurement_building.service_codes = ['M.1'] }

      it 'is not valid' do
        expect(procurement_building.valid?(:buildings_and_services)).to be false
      end

      it 'has the correct error message' do
        procurement_building.valid?(:buildings_and_services)
        expect(procurement_building.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system'"
      end

      context 'when another service is included as well' do
        before { procurement_building.service_codes << 'C.1' }

        it 'is valid' do
          expect(procurement_building.valid?(:buildings_and_services)).to be true
        end
      end
    end

    context 'when the only service codes selected are only O.1 and M.1' do
      before { procurement_building.service_codes = ['O.1', 'M.1'] }

      it 'is not valid' do
        expect(procurement_building.valid?(:buildings_and_services)).to be false
      end

      it 'has the correct error message' do
        procurement_building.valid?(:buildings_and_services)
        expect(procurement_building.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Management of billable works'"
      end

      context 'when another service is included as well' do
        before { procurement_building.service_codes << 'C.1' }

        it 'is valid' do
          expect(procurement_building.valid?(:buildings_and_services)).to be true
        end
      end
    end

    context 'when the only service codes selected are only O.1 and N.1' do
      before { procurement_building.service_codes = ['O.1', 'N.1'] }

      it 'is not valid' do
        expect(procurement_building.valid?(:buildings_and_services)).to be false
      end

      it 'has the correct error message' do
        procurement_building.valid?(:buildings_and_services)
        expect(procurement_building.errors[:service_codes].first).to eq "You must select another service to include 'Helpdesk services', 'Management of billable works'"
      end

      context 'when another service is included as well' do
        before { procurement_building.service_codes << 'C.1' }

        it 'is valid' do
          expect(procurement_building.valid?(:buildings_and_services)).to be true
        end
      end
    end

    context 'when the only service codes selected are only M.1 and N.1' do
      before { procurement_building.service_codes = ['M.1', 'N.1'] }

      it 'is not valid' do
        expect(procurement_building.valid?(:buildings_and_services)).to be false
      end

      it 'has the correct error message' do
        procurement_building.valid?(:buildings_and_services)
        expect(procurement_building.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services'"
      end

      context 'when another service is included as well' do
        before { procurement_building.service_codes << 'C.1' }

        it 'is valid' do
          expect(procurement_building.valid?(:buildings_and_services)).to be true
        end
      end
    end

    context 'when the only service codes selected are only O.1, N.1 and M.1' do
      before { procurement_building.service_codes = ['O.1', 'N.1', 'M.1'] }

      it 'is not valid' do
        expect(procurement_building.valid?(:buildings_and_services)).to be false
      end

      it 'has the correct error message' do
        procurement_building.valid?(:buildings_and_services)
        expect(procurement_building.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services', 'Management of billable works'"
      end

      context 'when another service is included as well' do
        before { procurement_building.service_codes << 'C.1' }

        it 'is valid' do
          expect(procurement_building.valid?(:buildings_and_services)).to be true
        end
      end
    end

    context 'when the only service codes selected include G.1 and G.3' do
      before { procurement_building.service_codes = ['G.1', 'G.3'] }

      it 'is not valid' do
        expect(procurement_building.valid?(:buildings_and_services)).to be false
      end

      it 'has the correct error message' do
        procurement_building.valid?(:buildings_and_services)
        expect(procurement_building.errors[:service_codes].first).to eq "'Mobile cleaning' and 'Routine cleaning' are the same, but differ by delivery method. Please choose one of these services only"
      end

      context 'when another service is included as well' do
        before { procurement_building.service_codes << 'C.1' }

        it 'is not valid' do
          expect(procurement_building.valid?(:buildings_and_services)).to be false
        end
      end
    end

    context 'when there are no services selected' do
      it 'is not valid' do
        expect(procurement_building.valid?(:buildings_and_services)).to be false
      end

      it 'returns the correct error message' do
        procurement_building.valid?(:buildings_and_services)

        expect(procurement_building.errors[:service_codes].first).to eq 'You must select at least one service for this building'
      end
    end

    context 'when a service is selected' do
      it 'is valid' do
        procurement_building.service_codes << 'C.1'

        expect(procurement_building.valid?(:buildings_and_services)).to be true
      end
    end
  end

  describe 'validations on procurement_building_services' do
    before do
      procurement_building.update(service_codes: ['C.5'])
      procurement_building.procurement_building_services.first.update(service_standard: 'B')
      procurement_building.reload
    end

    context 'when the service information is complete' do
      before do
        pbs = procurement_building.procurement_building_services.first
        [1, 2, 3, 4].each do |number_of_floors|
          pbs.lifts.create(number_of_floors:)
        end
        procurement_building.reload
      end

      it 'is valid' do
        expect(procurement_building.valid?(:procurement_building_services)).to be true
      end
    end

    context 'when the service information is not complete' do
      before { procurement_building.valid?(:procurement_building_services) }

      it 'is not valid' do
        expect(procurement_building.errors.any?).to be true
      end

      it 'has the correct errors' do
        expect(procurement_building.errors.details[:procurement_building_services].first[:error]).to eq :invalid
        expect(procurement_building.errors.details[:base].first[:error]).to eq :services_invalid
      end
    end
  end

  describe '#validate_internal_area' do
    context 'when the building has an internal area of 0' do
      before do
        procurement_building.procurement.update(aasm_state: 'detailed_search')
        procurement_building.service_codes << 'C.1'
        procurement_building.building.gia = 0
      end

      it 'is not valid on gia' do
        expect(procurement_building.valid?(:gia)).to be false
      end

      it 'has the correct error message' do
        procurement_building.valid?(:gia)
        expect(procurement_building.errors.messages[:building].first).to eq "You have a service in ‘#{procurement_building.building.building_name}’ building that requires internal area, please go to 'Manage buildings' to update the building internal area size"
      end
    end

    context 'when the building has an internal area' do
      it 'is valid on gia' do
        procurement_building.procurement.update(aasm_state: 'detailed_search')
        procurement_building.service_codes << 'C.1'
        expect(procurement_building.valid?(:gia)).to be true
      end
    end
  end

  describe '#validate_external_area' do
    context 'when the building has an external area of 0' do
      before do
        procurement_building.procurement.update(aasm_state: 'detailed_search')
        procurement_building.service_codes << 'G.5'
        procurement_building.building.external_area = 0
      end

      it 'is not valid on external_area' do
        expect(procurement_building.valid?(:external_area)).to be false
      end

      it 'has the correct error message' do
        procurement_building.valid?(:external_area)
        expect(procurement_building.errors.messages[:building].first).to eq "You have a service in ‘#{procurement_building.building.building_name}’ building that requires external area, please go to 'Manage buildings' to update the building external area size"
      end
    end

    context 'when the building has an internal area' do
      it 'is valid on external_area' do
        procurement_building.procurement.update(aasm_state: 'detailed_search')
        procurement_building.service_codes << 'G.5'
        expect(procurement_building.valid?(:external_area)).to be true
      end
    end
  end

  describe '#validate_spreadsheet_gia' do
    context 'when the building has an internal area of 0' do
      let(:gia) { 0 }

      before do
        procurement_building.service_codes << 'C.1'
        procurement_building.validate_spreadsheet_gia(gia, procurement_building.name)
      end

      it 'is not valid on gia' do
        expect(procurement_building.errors.any?).to be true
      end

      it 'has the correct error message' do
        expect(procurement_building.errors.messages[:building].first).to eq "You have a service in ‘#{procurement_building.building.building_name}’ building that requires internal area, please go to 'Manage buildings' to update the building internal area size"
      end
    end

    context 'when the building has an internal area' do
      let(:gia) { procurement_building.building.gia }

      it 'is valid on gia' do
        procurement_building.procurement.update(aasm_state: 'detailed_search')
        procurement_building.service_codes << 'C.1'
        procurement_building.validate_spreadsheet_gia(gia, procurement_building.name)

        expect(procurement_building.errors.any?).to be false
      end
    end
  end

  describe '#validate_spreadsheet_external_area' do
    context 'when the building has an internal area of 0' do
      let(:external_area) { 0 }

      before do
        procurement_building.service_codes << 'G.5'
        procurement_building.validate_spreadsheet_external_area(external_area, procurement_building.name)
      end

      it 'is not valid on gia' do
        expect(procurement_building.errors.any?).to be true
      end

      it 'has the correct error message' do
        expect(procurement_building.errors.messages[:building].first).to eq "You have a service in ‘#{procurement_building.building.building_name}’ building that requires external area, please go to 'Manage buildings' to update the building external area size"
      end
    end

    context 'when the building has an internal area' do
      let(:external_area) { procurement_building.building.external_area }

      it 'is valid on gia' do
        procurement_building.procurement.update(aasm_state: 'detailed_search')
        procurement_building.service_codes << 'G.5'
        procurement_building.validate_spreadsheet_external_area(external_area, procurement_building.name)

        expect(procurement_building.errors.any?).to be false
      end
    end
  end

  describe '#requires_internal_area?' do
    context 'when a service requires an internal area' do
      it 'is true' do
        procurement_building.service_codes = FacilitiesManagement::RM3830::Service.full_gia_services.sample(4)
        expect(procurement_building.send(:requires_internal_area?)).to be true
      end
    end

    context 'when a service does not require an internal area' do
      it 'is false' do
        procurement_building.service_codes = ['G.5']
        expect(procurement_building.send(:requires_internal_area?)).to be false
      end
    end
  end

  describe '#requires_external_area?' do
    context 'when a service requires an external area' do
      it 'is true' do
        procurement_building.service_codes = ['G.5']
        expect(procurement_building.send(:requires_external_area?)).to be true
      end
    end

    context 'when a service does not require an external area' do
      it 'is false' do
        procurement_building.service_codes = ['C.1']
        expect(procurement_building.send(:requires_external_area?)).to be false
      end
    end
  end

  describe '#building_internal_area' do
    before do
      procurement_building.building.update(gia: 500)
      procurement_building.update(gia: 1000)
    end

    context 'when the building is in a detailed search' do
      it 'uses the building gia for the internal area' do
        procurement_building.procurement.update(aasm_state: 'detailed_search')
        expect(procurement_building.send(:building_internal_area)).to eq 500
      end
    end

    context 'when the building is in a results state' do
      it 'uses the procurement_building gia for the internal area' do
        procurement_building.procurement.update(aasm_state: 'results')
        expect(procurement_building.send(:building_internal_area)).to eq 1000
      end
    end

    context 'when the building is in a da_draft state' do
      it 'uses the procurement_building gia for the internal area' do
        procurement_building.procurement.update(aasm_state: 'da_draft')
        expect(procurement_building.send(:building_internal_area)).to eq 1000
      end
    end
  end

  describe '#building_external_area' do
    before do
      procurement_building.building.update(external_area: 1000)
      procurement_building.update(external_area: 500)
    end

    context 'when the building is in a detailed search' do
      it 'uses the building external_area for the external area' do
        procurement_building.procurement.update(aasm_state: 'detailed_search')
        expect(procurement_building.send(:building_external_area)).to eq 1000
      end
    end

    context 'when the building is in a results state' do
      it 'uses the procurement_building external_area for the external area' do
        procurement_building.procurement.update(aasm_state: 'results')
        expect(procurement_building.send(:building_external_area)).to eq 500
      end
    end

    context 'when the building is in a da_draft state' do
      it 'uses the procurement_building external_area for the external area' do
        procurement_building.procurement.update(aasm_state: 'da_draft')
        expect(procurement_building.send(:building_external_area)).to eq 500
      end
    end
  end

  describe '#missing_region?' do
    before do
      procurement_building.building.update(address_region:, address_region_code:)
    end

    let(:address_region) { procurement_building.building.address_region }
    let(:address_region_code) { procurement_building.building.address_region_code }

    context 'when the building is missing address_region' do
      let(:address_region) { nil }

      it 'returns true' do
        expect(procurement_building.missing_region?).to be true
      end
    end

    context 'when the building is missing address_region_code' do
      let(:address_region_code) { nil }

      it 'returns true' do
        expect(procurement_building.missing_region?).to be true
      end
    end

    context 'when the building is missing address_region and address_region_code' do
      let(:address_region_code) { nil }
      let(:address_region) { nil }

      it 'returns true' do
        expect(procurement_building.missing_region?).to be true
      end
    end

    context 'when the building is not missing address_region or address_region_code' do
      it 'returns false' do
        expect(procurement_building.missing_region?).to be false
      end
    end
  end

  describe '#sorted_procurement_building_services' do
    context 'when the service codes are put ina random order' do
      let(:codes) { %w[C.1 E.4 C.2 C.3 C.4 G.3 C.5 C.11 K.4 I.3 O.1 N.1 D.1 E.1 G.1] }

      before do
        procurement_building.update(service_codes: codes.shuffle)
        procurement_building.reload
      end

      it 'returns the procurement_building_services in the work package order' do
        expect(procurement_building.sorted_procurement_building_services.map(&:code)).to eq %w[C.1 C.2 C.3 C.4 C.11 C.5 D.1 E.1 E.4 G.1 G.3 I.3 K.4 N.1 O.1]
      end
    end
  end

  describe '#service_selection_complete?' do
    before { procurement_building.update(service_codes:) }

    context 'when there are no service codes' do
      let(:service_codes) { [] }

      it 'returns false' do
        expect(procurement_building.service_selection_complete?).to be false
      end
    end

    context 'when the selection is invalid' do
      let(:service_codes) { %w[M.1 N.1 O.1] }

      it 'returns false' do
        expect(procurement_building.service_selection_complete?).to be false
      end
    end

    context 'when the slection is valid' do
      let(:service_codes) { %w[M.1 N.1 O.1 C.1] }

      it 'returns true' do
        expect(procurement_building.service_selection_complete?).to be true
      end
    end
  end

  describe '#complete?' do
    context 'when service require answers' do
      let(:codes_with_values) do
        {
          'C.1': { service_standard: c1_value },
          'G.3': { service_standard: g3_value1, no_of_building_occupants: g3_value2 },
          'G.5': { service_standard: g5_value },
          'C.5': { service_standard: c5_value1 },
          'H.5': { service_hours: h5_value, detail_of_requirement: 'Some details' },
          'H.16': {},
          'E.4': { no_of_appliances_for_testing: e4_value },
          'K.1': { no_of_consoles_to_be_serviced: k1_value },
          'K.2': { tones_to_be_collected_and_removed: k2_value },
          'K.7': { no_of_units_to_be_serviced: k7_value }
        }
      end

      let(:c1_value) { 'A' }
      let(:g3_value1) { 'B' }
      let(:g3_value2) { 58 }
      let(:g5_value) { 'A' }
      let(:c5_value1) { 'C' }
      let(:h5_value) { 406 }
      let(:e4_value) { 123 }
      let(:k1_value) { 234 }
      let(:k2_value) { 345 }
      let(:k7_value) { 456 }

      let(:lift_data) { [1, 2, 3, 4] }

      let(:gia) { 100 }
      let(:external_area) { 200 }

      before do
        procurement_building.procurement.update(aasm_state: 'detailed_search')
        service_codes = codes_with_values.map { |key, _| key.to_s } << 'C.5'
        procurement_building.update(service_codes:)
        procurement_building.reload
        procurement_building.procurement_building_services.each do |pbs|
          pbs.update(codes_with_values[pbs.code.to_sym])
        end
        pbs = procurement_building.procurement_building_services.find_by(code: 'C.5')
        lift_data.each do |number_of_floors|
          pbs.lifts.create(number_of_floors:)
        end
        procurement_building.building.update(gia:, external_area:)
      end

      context 'when a service requires gia and gia is zero' do
        let(:gia) { 0 }

        it 'returns false' do
          expect(procurement_building.complete?).to be false
        end
      end

      context 'when a service requires external_area and external_area is zero' do
        let(:external_area) { 0 }

        it 'returns false' do
          expect(procurement_building.complete?).to be false
        end
      end

      context 'when a service requires lift_data and lift_data is empty' do
        let(:lift_data) { [] }

        it 'returns false' do
          expect(procurement_building.complete?).to be false
        end
      end

      context 'when a service requires service_hours and service_hours is nil' do
        let(:h5_value) { nil }

        it 'returns false' do
          expect(procurement_building.complete?).to be false
        end
      end

      context 'when a service requires a no_of_appliances_for_testing and no_of_appliances_for_testing is nil' do
        let(:e4_value) { nil }

        it 'returns false' do
          expect(procurement_building.complete?).to be false
        end
      end

      context 'when a service requires a no_of_building_occupants and no_of_building_occupants is nil' do
        let(:g3_value2) { nil }

        it 'returns false' do
          expect(procurement_building.complete?).to be false
        end
      end

      context 'when a service requires a no_of_consoles_to_be_serviced and no_of_consoles_to_be_serviced is nil' do
        let(:k1_value) { nil }

        it 'returns false' do
          expect(procurement_building.complete?).to be false
        end
      end

      context 'when a service requires a tones_to_be_collected_and_removed and tones_to_be_collected_and_removed is nil' do
        let(:k2_value) { nil }

        it 'returns false' do
          expect(procurement_building.complete?).to be false
        end
      end

      context 'when a service requires a no_of_units_to_be_serviced and no_of_units_to_be_serviced is nil' do
        let(:k7_value) { nil }

        it 'returns false' do
          expect(procurement_building.complete?).to be false
        end
      end

      context 'when a service requires a service_standard and service_standard is nil' do
        let(:c1_value) { nil }

        it 'returns false' do
          expect(procurement_building.complete?).to be false
        end
      end

      context 'when all service questions are answered' do
        it 'returns true' do
          expect(procurement_building.complete?).to be true
        end
      end
    end

    context 'when the services do not require an answer' do
      before do
        procurement_building.procurement.update(aasm_state: 'detailed_search')
        procurement_building.update(service_codes: ['C.19', 'C.21', 'C.22'])
        procurement_building.update(gia: nil, external_area: nil)
        procurement_building.reload
      end

      it 'returns true' do
        expect(procurement_building.complete?).to be true
      end
    end
  end

  describe '#requires_service_questions?' do
    before do
      procurement_building.procurement.update(aasm_state: 'detailed_search')
      procurement_building.update(service_codes:)
      procurement_building.reload
    end

    context 'when no services have a service question' do
      let(:service_codes) { ['C.19', 'C.21', 'C.22'] }

      it 'returns false' do
        expect(procurement_building.send(:requires_service_questions?)).to be false
      end
    end

    context 'when one services have a service question' do
      let(:service_codes) { ['C.19', 'C.21', 'C.5'] }

      it 'returns true' do
        expect(procurement_building.send(:requires_service_questions?)).to be true
      end
    end

    context 'when all services have a service question' do
      let(:service_codes) { ['C.1', 'C.2', 'C.5'] }

      it 'returns true' do
        expect(procurement_building.send(:requires_service_questions?)).to be true
      end
    end
  end

  describe '.service_names' do
    before { procurement_building.update(service_codes: %w[F.1 C.21 M.1 C.5 L.1]) }

    it 'returns the service names sorted based on the work package' do
      expect(procurement_building.service_names).to eq(
        [
          'Lifts, hoists & conveyance systems maintenance',
          'Airport and aerodrome maintenance services',
          'Chilled potable water',
          'Childcare facility',
          'CAFM system'
        ]
      )
    end
  end
end
