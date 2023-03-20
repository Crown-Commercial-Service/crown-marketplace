require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Procurement do
  it { is_expected.to belong_to(:user) }

  describe '.quick_view_suppliers' do
    let(:procurement) { build(:facilities_management_rm6232_procurement_no_procurement_buildings, service_codes:) }
    let(:base_service_codes) { ['E.1', 'E.2'] }
    let(:service_codes) { base_service_codes }

    it 'returns a FacilitiesManagement::RM6232::SuppliersSelector' do
      expect(procurement.quick_view_suppliers).to be_a FacilitiesManagement::RM6232::SuppliersSelector
    end

    context 'when the service codes contain Q.3' do
      let(:service_codes) { base_service_codes + ['Q.3'] }

      it 'does not use that service code in the call to SuppliersSelector' do
        allow(FacilitiesManagement::RM6232::SuppliersSelector).to receive(:new)

        procurement.quick_view_suppliers

        expect(FacilitiesManagement::RM6232::SuppliersSelector).to have_received(:new).with(base_service_codes, procurement.region_codes, procurement.annual_contract_value)
      end
    end
  end

  describe '.supplier_names' do
    let(:procurement) { build(:facilities_management_rm6232_procurement_what_happens_next, service_codes:) }
    let(:base_service_codes) { ['E.1', 'E.2'] }
    let(:service_codes) { base_service_codes }

    it 'returns an array of the supplier names' do
      supplier = create(:facilities_management_rm6232_supplier, supplier_name: 'Still, Move Forward!')
      create(:facilities_management_rm6232_supplier_lot_data, supplier: supplier, lot_code: '2a', service_codes: procurement.service_codes, region_codes: procurement.region_codes)

      expect(procurement.supplier_names).to be_an(Array)
      expect(procurement.supplier_names).to include('Still, Move Forward!')
    end

    context 'when the service codes contain Q.3' do
      let(:service_codes) { base_service_codes + ['Q.3'] }
      let(:suppliers_selector) { instance_double(FacilitiesManagement::RM6232::SuppliersSelector) }
      let(:suppliers) { [] }

      it 'does not use that service code in the call to SuppliersSelector' do
        allow(FacilitiesManagement::RM6232::SuppliersSelector).to receive(:new).and_return(suppliers_selector)
        allow(suppliers_selector).to receive(:selected_suppliers).and_return(suppliers)
        allow(suppliers).to receive(:pluck)

        procurement.supplier_names

        expect(FacilitiesManagement::RM6232::SuppliersSelector).to have_received(:new).with(base_service_codes, procurement.region_codes, procurement.annual_contract_value, '2a')
      end
    end
  end

  describe '.suppliers' do
    let(:procurement) { create(:facilities_management_rm6232_procurement_results, service_codes: base_service_codes) }
    let(:base_service_codes) { ['E.1', 'E.2', 'E.3', 'E.4'] }
    let(:service_codes) { base_service_codes }

    it 'returns a FacilitiesManagement::RM6232::SuppliersSelector' do
      expect(procurement.suppliers).to be_a FacilitiesManagement::RM6232::SuppliersSelector
    end

    it 'uses the services and region codes from the procurement buildings' do
      allow(FacilitiesManagement::RM6232::SuppliersSelector).to receive(:new)

      procurement.suppliers

      expect(FacilitiesManagement::RM6232::SuppliersSelector).to have_received(:new).with(%w[E.1 E.2], %w[UKH1], procurement.annual_contract_value)
    end

    context 'when the service codes contain Q.3' do
      let(:service_codes) { base_service_codes + ['Q.3'] }

      before { procurement.procurement_buildings.each { |procurement_building| procurement_building.update(service_codes: procurement_building.service_codes + ['Q.3']) } }

      it 'does not use that service code in the call to SuppliersSelector' do
        allow(FacilitiesManagement::RM6232::SuppliersSelector).to receive(:new)

        procurement.suppliers

        expect(FacilitiesManagement::RM6232::SuppliersSelector).to have_received(:new).with(%w[E.1 E.2], %w[UKH1], procurement.annual_contract_value)
      end
    end
  end

  describe '.services' do
    let(:procurement) { build(:facilities_management_rm6232_procurement_what_happens_next, service_codes:, lot_number:) }
    let(:base_service_codes) { ['E.1', 'E.2'] }
    let(:service_codes) { base_service_codes }
    let(:lot_number) { '1a' }
    let(:result) { procurement.services }

    it 'returns an array of FacilitiesManagement::RM6232::Service' do
      expect(result.length).to eq 2
      expect(result.first).to be_a FacilitiesManagement::RM6232::Service
    end

    context 'when the service codes contain Q.3' do
      let(:service_codes) { base_service_codes + ['Q.3'] }
      let(:service_Q1) { FacilitiesManagement::RM6232::Service.find('Q.1') }
      let(:service_Q2) { FacilitiesManagement::RM6232::Service.find('Q.2') }
      let(:service_Q3) { FacilitiesManagement::RM6232::Service.find('Q.3') }

      context 'and it is a total sub lot' do
        let(:lot_number) { '1a' }

        it 'returns services with Q.2 instead of Q.3' do
          expect(result).not_to include service_Q3
          expect(result).to include service_Q2
        end
      end

      context 'and it is a hard sub lot' do
        let(:lot_number) { '2a' }

        it 'returns services with Q.2 instead of Q.3' do
          expect(result).not_to include service_Q3
          expect(result).to include service_Q2
        end
      end

      context 'and it is a soft sub lot' do
        let(:lot_number) { '3a' }

        it 'returns services with Q.1 instead of Q.3' do
          expect(result).not_to include service_Q3
          expect(result).to include service_Q1
        end
      end
    end
  end

  describe '.procurement_services' do
    let(:procurement) { create(:facilities_management_rm6232_procurement_results, service_codes:, lot_number:) }
    let(:base_service_codes) { ['E.1', 'E.2', 'E.3', 'E.4', 'E.5'] }
    let(:service_codes) { base_service_codes }
    let(:lot_number) { '1a' }
    let(:result) { procurement.procurement_services }

    it 'returns an array of FacilitiesManagement::RM6232::Service' do
      expect(result.length).to eq 2
      expect(result.first).to be_a FacilitiesManagement::RM6232::Service
    end

    context 'when the service codes contain Q.3' do
      let(:service_codes) { base_service_codes + ['Q.3'] }
      let(:service_Q1) { FacilitiesManagement::RM6232::Service.find('Q.1') }
      let(:service_Q2) { FacilitiesManagement::RM6232::Service.find('Q.2') }
      let(:service_Q3) { FacilitiesManagement::RM6232::Service.find('Q.3') }

      before { procurement.procurement_buildings.each { |procurement_building| procurement_building.update(service_codes: procurement_building.service_codes + ['Q.3']) } }

      context 'and it is a total sub lot' do
        let(:lot_number) { '1a' }

        it 'returns services with Q.2 instead of Q.3' do
          expect(result).not_to include service_Q3
          expect(result).to include service_Q2
        end
      end

      context 'and it is a hard sub lot' do
        let(:lot_number) { '2a' }

        it 'returns services with Q.2 instead of Q.3' do
          expect(result).not_to include service_Q3
          expect(result).to include service_Q2
        end
      end

      context 'and it is a soft sub lot' do
        let(:lot_number) { '3a' }

        it 'returns services with Q.1 instead of Q.3' do
          expect(result).not_to include service_Q3
          expect(result).to include service_Q1
        end
      end
    end
  end

  describe '.services_without_lot_consideration' do
    let(:procurement) { build(:facilities_management_rm6232_procurement_what_happens_next, service_codes:, lot_number:) }
    let(:base_service_codes) { ['E.1', 'E.2'] }
    let(:service_codes) { base_service_codes }
    let(:lot_number) { '1a' }

    it 'returns an array of FacilitiesManagement::RM6232::Service' do
      expect(procurement.services_without_lot_consideration.length).to eq 2
      expect(procurement.services_without_lot_consideration.first).to be_a FacilitiesManagement::RM6232::Service
    end

    context 'when the service codes contain Q.3' do
      let(:service_codes) { base_service_codes + ['Q.3'] }
      let(:service_Q1) { FacilitiesManagement::RM6232::Service.find('Q.1') }
      let(:service_Q2) { FacilitiesManagement::RM6232::Service.find('Q.2') }
      let(:service_Q3) { FacilitiesManagement::RM6232::Service.find('Q.3') }

      context 'and it is a total sub lot' do
        let(:lot_number) { '1a' }

        it 'returns services with Q.3 instead of Q.2' do
          expect(procurement.services_without_lot_consideration).not_to include service_Q2
          expect(procurement.services_without_lot_consideration).to include service_Q3
        end
      end

      context 'and it is a hard sub lot' do
        let(:lot_number) { '2a' }

        it 'returns services with Q.3 instead of Q.2' do
          expect(procurement.services_without_lot_consideration).not_to include service_Q2
          expect(procurement.services_without_lot_consideration).to include service_Q3
        end
      end

      context 'and it is a soft sub lot' do
        let(:lot_number) { '3a' }

        it 'returns services with Q.3 instead of Q.1' do
          expect(procurement.services_without_lot_consideration).not_to include service_Q1
          expect(procurement.services_without_lot_consideration).to include service_Q3
        end
      end
    end
  end

  describe '.regions' do
    let(:procurement) { build(:facilities_management_rm6232_procurement_what_happens_next) }

    it 'returns an array of FacilitiesManagement::Region' do
      expect(procurement.regions.length).to eq 2
      expect(procurement.regions.first).to be_a FacilitiesManagement::Region
    end
  end

  describe '.service_codes_without_cafm' do
    let(:procurement) { build(:facilities_management_rm6232_procurement_what_happens_next, service_codes:) }
    let(:base_service_codes) { ['E.1', 'E.2', 'F.1', 'F.2', 'H.1'] }

    context 'when the service codes contain Q.3' do
      let(:service_codes) { base_service_codes + ['Q.3'] }

      it 'returns the service codes without Q.3' do
        expect(procurement.service_codes).to eq service_codes
        expect(procurement.send(:service_codes_without_cafm)).to eq base_service_codes
      end
    end

    context 'when the service codes do not contain Q.3' do
      let(:service_codes) { base_service_codes }

      it 'returns the service codes unchanged' do
        expect(procurement.service_codes).to eq service_codes
        expect(procurement.send(:service_codes_without_cafm)).to eq service_codes
      end
    end
  end

  describe '.true_service_codes' do
    let(:procurement) { build(:facilities_management_rm6232_procurement_what_happens_next, service_codes:, lot_number:) }
    let(:base_service_codes) { ['E.1', 'E.2', 'F.1', 'F.2', 'H.1'] }
    let(:lot_number) { '1a' }

    context 'when the service codes contain Q.3' do
      let(:service_codes) { base_service_codes + ['Q.3'] }

      context 'and the lot is 1a' do
        let(:lot_number) { '1a' }

        it 'returns the services with Q.2 instead of Q.3' do
          expect(procurement.send(:true_service_codes)).to eq base_service_codes + ['Q.2']
        end
      end

      context 'and the lot is 2a' do
        let(:lot_number) { '2a' }

        it 'returns the services with Q.2 instead of Q.3' do
          expect(procurement.send(:true_service_codes)).to eq base_service_codes + ['Q.2']
        end
      end

      context 'and the lot is 3a' do
        let(:lot_number) { '3a' }

        it 'returns the services with Q.1 instead of Q.3' do
          expect(procurement.send(:true_service_codes)).to eq base_service_codes + ['Q.1']
        end
      end

      context 'and the lot is 1b' do
        let(:lot_number) { '1b' }

        it 'returns the services with Q.2 instead of Q.3' do
          expect(procurement.send(:true_service_codes)).to eq base_service_codes + ['Q.2']
        end
      end

      context 'and the lot is 2b' do
        let(:lot_number) { '2b' }

        it 'returns the services with Q.2 instead of Q.3' do
          expect(procurement.send(:true_service_codes)).to eq base_service_codes + ['Q.2']
        end
      end

      context 'and the lot is 3b' do
        let(:lot_number) { '3b' }

        it 'returns the services with Q.1 instead of Q.3' do
          expect(procurement.send(:true_service_codes)).to eq base_service_codes + ['Q.1']
        end
      end

      context 'and the lot is 1c' do
        let(:lot_number) { '1c' }

        it 'returns the services with Q.2 instead of Q.3' do
          expect(procurement.send(:true_service_codes)).to eq base_service_codes + ['Q.2']
        end
      end

      context 'and the lot is 2c' do
        let(:lot_number) { '2c' }

        it 'returns the services with Q.2 instead of Q.3' do
          expect(procurement.send(:true_service_codes)).to eq base_service_codes + ['Q.2']
        end
      end

      context 'and the lot is 3c' do
        let(:lot_number) { '3c' }

        it 'returns the services with Q.1 instead of Q.3' do
          expect(procurement.send(:true_service_codes)).to eq base_service_codes + ['Q.1']
        end
      end
    end

    context 'when the service codes do not contain Q.3' do
      let(:service_codes) { base_service_codes }

      it 'returns the service codes unchanged' do
        expect(procurement.service_codes).to eq service_codes
        expect(procurement.send(:true_service_codes)).to eq service_codes
      end
    end
  end

  describe 'before_create' do
    context 'when a procurement is created' do
      let(:procurement) { build(:facilities_management_rm6232_procurement_no_procurement_buildings, lot_number: nil, contract_number: nil) }

      # rubocop:disable RSpec/MultipleExpectations
      it 'sets the contract number and lot number' do
        expect(procurement.contract_number).to be_nil
        expect(procurement.lot_number).to be_nil

        procurement.save

        expect(procurement.contract_number).not_to be_nil
        expect(procurement.lot_number).not_to be_nil
      end
      # rubocop:enable RSpec/MultipleExpectations
    end

    context 'when considering the contract number' do
      let(:procurement) { create(:facilities_management_rm6232_procurement_no_procurement_buildings, :skip_determine_lot_number) }

      it 'has the correct format' do
        expect(procurement.contract_number).to match(/\ARM6232-\d{6}-\d{4}\z/)
      end

      it 'has the current year as the final 4 digits' do
        current_year = Date.current.year.to_s

        expect(procurement.contract_number.split('-')[2]).to eq(current_year)
      end
    end

    # rubocop:disable RSpec/NestedGroups
    context 'when considering the lot number' do
      let(:procurement) { create(:facilities_management_rm6232_procurement_no_procurement_buildings, :skip_generate_contract_number, lot_number: nil, annual_contract_value: annual_contract_value, service_codes: service_codes) }
      let(:selection_one) { { total: false, hard: false, soft: false } }
      let(:selection_two) { { total: false, hard: false, soft: false } }
      let(:service_codes) { FacilitiesManagement::RM6232::Service.where(**selection_one).sample(3).pluck(:code) + FacilitiesManagement::RM6232::Service.where(**selection_two).sample(3).pluck(:code) }
      let(:result) { procurement.lot_number }

      context 'when all services are hard' do
        let(:selection_one) { { total: true, hard: true, soft: false } }

        context 'and the annual_contract_value is less than 1,500,000' do
          let(:annual_contract_value) { rand(1_500_000) }

          it 'returns 2a' do
            expect(result).to eq '2a'
          end
        end

        context 'and the annual_contract_value is a more than 1,500,000 and less than 10,000,000' do
          let(:annual_contract_value) { rand(1_500_000...10_000_000) }

          it 'returns 2b' do
            expect(result).to eq '2b'
          end
        end

        context 'and the annual_contract_value is more than 10,000,000' do
          let(:annual_contract_value) { rand(10_000_000...50_000_000) }

          it 'returns 2c' do
            expect(result).to eq '2c'
          end
        end
      end

      context 'when all services are soft' do
        let(:selection_one) { { total: true, hard: false, soft: true } }

        context 'and the annual_contract_value is less than 1,000,000' do
          let(:annual_contract_value) { rand(1_000_000) }

          it 'returns 3a' do
            expect(result).to eq '3a'
          end
        end

        context 'and the annual_contract_value is a more than 1,000,000 and less than 7,000,000' do
          let(:annual_contract_value) { rand(1_000_000...7_000_000) }

          it 'returns 3b' do
            expect(result).to eq '3b'
          end
        end

        context 'and the annual_contract_value is more than 7,000,000' do
          let(:annual_contract_value) { rand(7_000_000...50_000_000) }

          it 'returns 3c' do
            expect(result).to eq '3c'
          end
        end
      end

      context 'when there are a mix of hard and soft' do
        let(:selection_one) { { total: true, hard: true, soft: false } }
        let(:selection_two) { { total: true, hard: false, soft: true } }

        context 'and the annual_contract_value is less than 1,500,000' do
          let(:annual_contract_value) { rand(1_500_000) }

          it 'returns 1a' do
            expect(result).to eq '1a'
          end
        end

        context 'and the annual_contract_value is a more than 1,500,000 and less than 10,000,000' do
          let(:annual_contract_value) { rand(1_500_000...10_000_000) }

          it 'returns 1b' do
            expect(result).to eq '1b'
          end
        end

        context 'and the annual_contract_value is more than 10,000,000' do
          let(:annual_contract_value) { rand(10_000_000...50_000_000) }

          it 'returns 1c' do
            expect(result).to eq '1c'
          end
        end
      end
    end
    # rubocop:enable RSpec/NestedGroups
  end

  describe 'aasm_state' do
    let(:procurement) { build(:facilities_management_rm6232_procurement_what_happens_next, aasm_state: state) }

    context 'when considering the initial state' do
      let(:procurement) { build(:facilities_management_rm6232_procurement_what_happens_next) }

      it 'is what_happens_next' do
        expect(procurement.what_happens_next?).to be true
      end
    end

    context 'when the event set_to_next_state is called' do
      before do
        allow(procurement).to receive(:freeze_data)
        allow(procurement).to receive(:determine_lot)
        procurement.set_to_next_state
      end

      context 'and the state is what_happens_next' do
        let(:state) { 'what_happens_next' }

        it 'changes the state to entering_requirements' do
          expect(procurement.entering_requirements?).to be true
        end
      end

      context 'and the state is entering_requirements' do
        let(:state) { 'entering_requirements' }

        it 'changes the state to results' do
          expect(procurement.results?).to be true
        end

        it 'calls freeze_data and determine_lot' do
          expect(procurement).to have_received(:freeze_data)
          expect(procurement).to have_received(:determine_lot)
        end
      end

      context 'and the state is results' do
        let(:state) { 'results' }

        it 'changes the state to further_information' do
          expect(procurement.further_information?).to be true
        end
      end
    end

    context 'when considering the callbacks when the state is changed to results' do
      let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements_with_buildings, annual_contract_value: 20_000_000) }
      let(:procurement_building_1) { procurement.procurement_buildings.first }
      let(:procurement_building_2) { procurement.procurement_buildings.last }

      it 'freezes the building data' do
        expect do
          procurement.set_to_next_state!
          procurement_building_1.reload
          procurement_building_2.reload
        end.to(
          change(procurement_building_1, :frozen_building_data).from({})
          .and(change(procurement_building_2, :frozen_building_data).from({}))
        )
      end

      it 'sets the lot number' do
        expect do
          procurement.set_to_next_state!
          procurement.reload
        end.to(
          change(procurement, :lot_number).from('2a').to('2c')
        )
      end
    end
  end

  describe 'scope' do
    before do
      create(:facilities_management_rm6232_procurement_what_happens_next, aasm_state: 'what_happens_next', contract_name: 'WHN procurement 1')
      create(:facilities_management_rm6232_procurement_what_happens_next, aasm_state: 'results', contract_name: 'R procurement 1')
      create(:facilities_management_rm6232_procurement_what_happens_next, aasm_state: 'further_information', contract_name: 'FC procurement 1')
      create(:facilities_management_rm6232_procurement_what_happens_next, aasm_state: 'what_happens_next', contract_name: 'WHN procurement 2')
      create(:facilities_management_rm6232_procurement_what_happens_next, aasm_state: 'entering_requirements', contract_name: 'ER procurement 1')
      create(:facilities_management_rm6232_procurement_what_happens_next, aasm_state: 'further_information', contract_name: 'FC procurement 2')
    end

    context 'when the searches scope is called' do
      it 'returns the epxected procurements in the right order' do
        searches = described_class.searches

        expect(searches.length).to eq 4
        expect(searches.map(&:contract_name)).to eq ['WHN procurement 1', 'WHN procurement 2', 'ER procurement 1', 'R procurement 1']
      end

      it 'has the right data' do
        expect(described_class.searches.first.attributes.keys).to eq(%w[id contract_name aasm_state initial_call_off_start_date updated_at])
      end
    end

    context 'when the advanced_procurement_activities scope is called' do
      it 'returns the epxected procurements in the right order' do
        advanced_procurement_activities = described_class.advanced_procurement_activities

        expect(advanced_procurement_activities.length).to eq 2
        expect(advanced_procurement_activities.map(&:contract_name)).to eq ['FC procurement 1', 'FC procurement 2']
      end

      it 'has the right data' do
        expect(described_class.advanced_procurement_activities.first.attributes.keys).to eq(%w[id contract_name initial_call_off_start_date contract_number updated_at])
      end
    end
  end

  describe '.contract_name_status' do
    subject(:status) { procurement.contract_name_status }

    let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, contract_name:) }

    context 'when the contract name section has not been completed' do
      let(:contract_name) { '' }

      it 'has a status of not_started' do
        expect(status).to eq(:not_started)
      end
    end

    context 'when the contract name section has been completed' do
      let(:contract_name) { 'My contract name' }

      it 'has a status of completed' do
        expect(status).to eq(:completed)
      end
    end
  end

  describe '.annual_contract_value_status' do
    subject(:status) { procurement.annual_contract_value_status }

    let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, annual_contract_value:) }

    context 'when the annual contract cost section has not been completed' do
      let(:annual_contract_value) { nil }

      it 'has a status of not_started' do
        expect(status).to eq(:not_started)
      end
    end

    context 'when the annual contract cost section has been completed' do
      let(:annual_contract_value) { 123_456 }

      it 'has a status of completed' do
        expect(status).to eq(:completed)
      end
    end
  end

  describe '.tupe_status' do
    subject(:status) { procurement.tupe_status }

    let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, tupe:) }

    context 'when the tupe section has not been completed' do
      let(:tupe) { nil }

      it 'has a status of not_started' do
        expect(status).to eq(:not_started)
      end
    end

    context 'when the tupe section has been completed' do
      let(:tupe) { true }

      it 'has a status of completed' do
        expect(status).to eq(:completed)
      end
    end
  end

  describe '.contract_period_status' do
    subject(:status) { procurement.contract_period_status }

    context 'when all contract period sections have not been started' do
      let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, initial_call_off_period_years: nil, initial_call_off_period_months: nil, initial_call_off_start_date: nil, mobilisation_period_required: nil, extensions_required: nil) }

      it 'has a status of not_started' do
        expect(status).to eq(:not_started)
      end
    end

    context 'when all contract period sections have not been completed' do
      let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, initial_call_off_period_months: nil, mobilisation_period_required: false, extensions_required: false) }

      it 'has a status of not_started' do
        expect(status).to eq(:incomplete)
      end
    end

    context 'when all contract period sections have been completed' do
      let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, mobilisation_period_required: false, extensions_required: false) }

      it 'has a status of completed' do
        expect(status).to eq(:completed)
      end
    end
  end

  describe '.services_status' do
    subject(:status) { procurement.services_status }

    let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, service_codes:) }

    context 'when user has not yet selected services' do
      let(:service_codes) { [] }

      it 'shown with the NOT STARTED status label' do
        expect(status).to eq(:not_started)
      end
    end

    context 'when user has already selected services' do
      let(:service_codes) { %w[E.1 E.2] }

      it 'shown with the COMPLETED status label' do
        expect(status).to eq(:completed)
      end
    end
  end

  describe '.buildings_status' do
    subject(:status) { procurement.buildings_status }

    context 'when user has not yet selected buildings' do
      let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements) }

      it 'shown with the NOT STARTED status label' do
        expect(status).to eq(:not_started)
      end
    end

    context 'when user has already selected buildings' do
      let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements_with_buildings) }

      it 'shown with the COMPLETED status label' do
        expect(status).to eq(:completed)
      end
    end
  end

  shared_context 'with buildings and services' do
    let(:procurement) do
      create(:facilities_management_rm6232_procurement_entering_requirements, procurement_buildings:)
    end

    let(:procurement_buildings) { [procurement_building1, procurement_building2] }

    let(:procurement_building1) { build(:facilities_management_rm6232_procurement_building) }
    let(:procurement_building2) { build(:facilities_management_rm6232_procurement_building) }
  end

  describe '.buildings_and_services_completed' do
    include_context 'with buildings and services'

    before do
      procurement_building1.update(service_codes:)
      procurement_building2.update(service_codes: %w[E.1 E.2])
    end

    context 'when one building has no service codes' do
      let(:service_codes) { [] }

      it 'returns false' do
        expect(procurement.buildings_and_services_completed?).to be false
      end
    end

    context 'when one building has an invalid selection' do
      let(:service_codes) { %w[Q.3 R.1 S.1] }

      it 'returns false' do
        expect(procurement.buildings_and_services_completed?).to be false
      end
    end

    context 'when both buildings have a valid selection' do
      let(:service_codes) { %w[Q.3 R.1 S.1 E.1] }

      it 'returns true' do
        expect(procurement.buildings_and_services_completed?).to be true
      end
    end
  end

  describe '.buildings_and_services_status' do
    subject(:status) { procurement.buildings_and_services_status }

    include_context 'with buildings and services'

    context 'when both Services and Buildings tasks are not COMPLETED yet' do
      before do
        allow(procurement).to receive(:services_status).and_return(:not_started)
        allow(procurement).to receive(:buildings_status).and_return(:not_started)
      end

      it 'shown with the CANNOT START YET status label' do
        expect(status).to eq(:cannot_start)
      end
    end

    context 'when both Services and Buildings tasks are COMPLETED' do
      before do
        allow(procurement).to receive(:services_status).and_return(:completed)
        allow(procurement).to receive(:buildings_status).and_return(:completed)
      end

      context 'when no service has been assigned to any building yet' do
        before do
          procurement_building1.update(service_codes: [])
          procurement_building2.update(service_codes: [])
        end

        it 'shown with the NOT STARTED status label' do
          expect(status).to eq(:incomplete)
        end
      end

      context 'when at least one service is assigned to each and every building' do
        before do
          procurement_building1.update(service_codes: ['E.1'])
          procurement_building2.update(service_codes: ['F.1', 'G.4', 'R.1'])
        end

        it 'shown with the COMPLETED status label' do
          expect(status).to eq(:completed)
        end
      end
    end
  end

  describe '.initial_call_off_period' do
    let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, initial_call_off_period_years:, initial_call_off_period_months:) }

    context 'when the years are 0 and months 3' do
      let(:initial_call_off_period_years) { 0 }
      let(:initial_call_off_period_months) { 3 }

      it 'is 3 months' do
        expect(procurement.initial_call_off_period).to eq(3.months)
      end
    end

    context 'when the years are 4 and months are 0' do
      let(:initial_call_off_period_years) { 4 }
      let(:initial_call_off_period_months) { 0 }

      it 'is 4 years' do
        expect(procurement.initial_call_off_period).to eq(4.years)
      end
    end

    context 'when the years are 2 and months are 6' do
      let(:initial_call_off_period_years) { 2 }
      let(:initial_call_off_period_months) { 6 }

      it 'is 2 years and 6 months' do
        expect(procurement.initial_call_off_period).to eq(2.years + 6.months)
      end
    end
  end

  describe '.initial_call_off_end_date' do
    let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, initial_call_off_period_years:, initial_call_off_period_months:, initial_call_off_start_date:) }

    context 'when the start date is 2022/03/01 and the period is 3 years and 4 months' do
      let(:initial_call_off_start_date) { Time.new(2022, 3, 1).in_time_zone('London') }
      let(:initial_call_off_period_years) { 3 }
      let(:initial_call_off_period_months) { 4 }

      it 'the initial call-off end date is 2025/06/30' do
        expect(procurement.initial_call_off_end_date).to eq(Time.new(2025, 6, 30).in_time_zone('London').to_date)
      end
    end

    context 'when the start date is 2021/28/02 and the period is 6 years and 1 month' do
      let(:initial_call_off_start_date) { Time.new(2021, 2, 28).in_time_zone('London') }
      let(:initial_call_off_period_years) { 6 }
      let(:initial_call_off_period_months) { 1 }

      it 'the initial call-off end date is 2027/03/27' do
        expect(procurement.initial_call_off_end_date).to eq(Time.new(2027, 3, 27).in_time_zone('London').to_date)
      end
    end

    context 'when the start date is 2021/07/18 and the period is 1 years and 7 months' do
      let(:initial_call_off_start_date) { Time.new(2021, 7, 18).in_time_zone('London') }
      let(:initial_call_off_period_years) { 1 }
      let(:initial_call_off_period_months) { 7 }

      it 'the initial call-off end date is 2023/02/17' do
        expect(procurement.initial_call_off_end_date).to eq(Time.new(2023, 2, 17).in_time_zone('London').to_date)
      end
    end

    context 'when the start date is 2024/02/29 and the period is 5 years and 0 months' do
      let(:initial_call_off_start_date) { Time.new(2024, 2, 29).in_time_zone('London') }
      let(:initial_call_off_period_years) { 5 }
      let(:initial_call_off_period_months) { 0 }

      it 'the initial call-off end date is 2029/02/28' do
        expect(procurement.initial_call_off_end_date).to eq(Time.new(2029, 2, 28).in_time_zone('London').to_date)
      end
    end

    context 'when the start date is 2022/01/31 and the period is 0 years and 5 months' do
      let(:initial_call_off_start_date) { Time.new(2022, 1, 31).in_time_zone('London') }
      let(:initial_call_off_period_years) { 0 }
      let(:initial_call_off_period_months) { 5 }

      it 'the initial call-off end date is 2022/06/30' do
        expect(procurement.initial_call_off_end_date).to eq(Time.new(2022, 6, 30).in_time_zone('London').to_date)
      end
    end

    context 'when the start date is 2023/10/10 and the period is 6 years and 3 months' do
      let(:initial_call_off_start_date) { Time.new(2023, 10, 10).in_time_zone('London') }
      let(:initial_call_off_period_years) { 6 }
      let(:initial_call_off_period_months) { 3 }

      it 'the initial call-off end date is 2030/01/9' do
        expect(procurement.initial_call_off_end_date).to eq(Time.new(2030, 1, 9).in_time_zone('London').to_date)
      end
    end
  end

  describe 'mobilisation period start and end dates' do
    let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements) }

    context 'when considering the mobilisation_end_date' do
      it 'is one day before the initial_call_off_start_date' do
        expect(procurement.mobilisation_end_date).to eq(procurement.initial_call_off_start_date - 1.day)
      end
    end

    context 'when considering the mobilisation_start_date' do
      before { procurement.mobilisation_period = mobilisation_period }

      context 'and the mobilisation_period is 2 weeks' do
        let(:mobilisation_period) { 2 }

        it 'is 2 weeks and a day before the initial_call_off_start_date' do
          expect(procurement.mobilisation_start_date).to eq(procurement.initial_call_off_start_date - 2.weeks - 1.day)
        end
      end

      context 'and the mobilisation_period is 4 weeks' do
        let(:mobilisation_period) { 4 }

        it 'is 4 weeks and a day before the initial_call_off_start_date' do
          expect(procurement.mobilisation_start_date).to eq(procurement.initial_call_off_start_date - 4.weeks - 1.day)
        end
      end

      context 'and the mobilisation_period is 8 weeks' do
        let(:mobilisation_period) { 8 }

        it 'is 8 weeks and a day before the initial_call_off_start_date' do
          expect(procurement.mobilisation_start_date).to eq(procurement.initial_call_off_start_date - 8.weeks - 1.day)
        end
      end
    end
  end

  describe 'extension periods start and end dates' do
    let(:procurement) { create(:facilities_management_rm6232_procurement_with_extension_periods) }

    describe 'extension_period_start_date' do
      context 'when there is one extenesion period' do
        it 'is expected to return the date one day after the end of the initial call off period' do
          expect(procurement.extension_period_start_date(0)).to eq(procurement.initial_call_off_end_date + 1.day)
        end
      end

      context 'when there is a second extension period' do
        it 'is expected to return the date one day after the end of the first extension period' do
          extension_period_start_date = procurement.initial_call_off_end_date + procurement.call_off_extensions.where(extension: 0..0).sum(&:period)

          expect(procurement.extension_period_start_date(1)).to eq(extension_period_start_date + 1.day)
        end
      end

      context 'when there is a third extension period' do
        it 'is expected to return the date one day after the end of the second extension period' do
          extension_period_start_date = procurement.initial_call_off_end_date + procurement.call_off_extensions.where(extension: 0..1).sum(&:period)

          expect(procurement.extension_period_start_date(2)).to eq(extension_period_start_date + 1.day)
        end
      end

      context 'when there is a forth extension period' do
        it 'is expected to return the date one day after the end of the third extension period' do
          extension_period_start_date = procurement.initial_call_off_end_date + procurement.call_off_extensions.where(extension: 0..2).sum(&:period)

          expect(procurement.extension_period_start_date(3)).to eq(extension_period_start_date + 1.day)
        end
      end
    end

    describe 'extension_period_end_date' do
      context 'when there is one extenesion period' do
        it 'is expected to return the date one year after the end of the initial call off period' do
          extension_period_end_date = procurement.initial_call_off_end_date + procurement.call_off_extensions.where(extension: 0..0).sum(&:period)

          expect(procurement.extension_period_end_date(0)).to eq(extension_period_end_date)
        end
      end

      context 'when there is a second extension period' do
        it 'is expected to return the date one year after the end of the first extension period' do
          extension_period_end_date = procurement.initial_call_off_end_date + procurement.call_off_extensions.where(extension: 0..1).sum(&:period)

          expect(procurement.extension_period_end_date(1)).to eq(extension_period_end_date)
        end
      end

      context 'when there is a third extension period' do
        it 'is expected to return the date one year after the end of the second extension period' do
          extension_period_end_date = procurement.initial_call_off_end_date + procurement.call_off_extensions.where(extension: 0..2).sum(&:period)

          expect(procurement.extension_period_end_date(2)).to eq(extension_period_end_date)
        end
      end

      context 'when there is a forth extension period' do
        it 'is expected to return the date one year after the end of the third extension period' do
          extension_period_end_date = procurement.initial_call_off_end_date + procurement.call_off_extensions.where(extension: 0..3).sum(&:period)

          expect(procurement.extension_period_end_date(3)).to eq(extension_period_end_date)
        end
      end
    end
  end

  describe '.active_procurement_buildings' do
    let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements) }
    let(:result) { procurement.active_procurement_buildings }

    context 'when there are no procurement buildings' do
      it 'returns no procurement buildings' do
        expect(result).to be_empty
      end
    end

    context 'when there are procurement buildings' do
      let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements_with_buildings) }
      let(:building_1) { procurement.procurement_buildings.first }
      let(:building_2) { procurement.procurement_buildings.last }

      context 'and none are active' do
        before { procurement.procurement_buildings.each { |procurement_building| procurement_building.update(active: false) } }

        it 'returns no procurement buildings' do
          expect(result).to be_empty
        end
      end

      context 'and some are active' do
        before { building_1.update(active: false) }

        it 'returns only the procurement buildings that are active' do
          expect(result.count).to eq 1
          expect(result.class.to_s).to eq 'FacilitiesManagement::RM6232::ProcurementBuilding::ActiveRecord_AssociationRelation'
          expect(result).to contain_exactly(building_2)
        end
      end

      context 'and all are active' do
        it 'returns all the procurement buildings' do
          expect(result.count).to eq 2
          expect(result.class.to_s).to eq 'FacilitiesManagement::RM6232::ProcurementBuilding::ActiveRecord_AssociationRelation'
          expect(result.sort).to match_array([building_1, building_2].sort)
        end
      end
    end
  end

  describe '.update_procurement_building_service_codes' do
    let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements_with_buildings) }
    let(:building_1) { procurement.procurement_buildings.first }
    let(:building_2) { procurement.procurement_buildings.last }
    let(:service_codes) { %w[E.1] }
    let(:saving_the_procurement) do
      procurement.service_codes = service_codes
      procurement.save(context: :services)
    end

    before { procurement.procurement_buildings.each { |procurement_building| procurement_building.update(service_codes: procurement.service_codes) } }

    context 'when there are procurement buildings none active' do
      before { procurement.procurement_buildings.each { |procurement_building| procurement_building.update(active: false) } }

      it 'updates all the procurement buildings' do
        expect do
          saving_the_procurement
        end.to(
          change(building_1, :service_codes).from(%w[E.1 E.2]).to(%w[E.1])
          .and(change(building_2, :service_codes).from(%w[E.1 E.2]).to(%w[E.1]))
        )
      end
    end

    context 'when there are procurement buildings with some active' do
      before { building_1.update(active: false) }

      it 'updates all the procurement buildings' do
        expect do
          saving_the_procurement
        end.to(
          change(building_1, :service_codes).from(%w[E.1 E.2]).to(%w[E.1])
          .and(change(building_2, :service_codes).from(%w[E.1 E.2]).to(%w[E.1]))
        )
      end
    end

    context 'when there are procurement buildings with all active' do
      it 'updates all the procurement buildings' do
        expect do
          saving_the_procurement
        end.to(
          change(building_1, :service_codes).from(%w[E.1 E.2]).to(%w[E.1])
          .and(change(building_2, :service_codes).from(%w[E.1 E.2]).to(%w[E.1]))
        )
      end
    end

    context 'when no service codes are changed' do
      let(:service_codes) { %w[E.1 E.2] }

      before { allow(procurement).to receive(:update_procurement_building_service_codes) }

      it 'updates no procurement buildings' do
        saving_the_procurement

        expect(procurement).not_to have_received(:update_procurement_building_service_codes)
      end
    end
  end

  describe '.procurement_buildings_missing_regions?' do
    let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements_with_buildings, aasm_state: state) }

    context 'when the procurement is in a what_happens_next state' do
      let(:state) { 'what_happens_next' }

      it 'returns false' do
        expect(procurement.procurement_buildings_missing_regions?).to be false
      end
    end

    context 'when the procurement is in entering_requirements' do
      let(:state) { 'entering_requirements' }

      context 'when a building address region is nil' do
        before { procurement.active_procurement_buildings.first.building.update(address_region_code: nil) }

        it 'returns true' do
          expect(procurement.procurement_buildings_missing_regions?).to be true
        end
      end

      context 'when a building address region is empty' do
        before { procurement.active_procurement_buildings.first.building.update(address_region_code: '') }

        it 'returns true' do
          expect(procurement.procurement_buildings_missing_regions?).to be true
        end
      end

      context 'when a building address region is present' do
        it 'returns false' do
          expect(procurement.procurement_buildings_missing_regions?).to be false
        end
      end
    end
  end

  describe '.procurement_buildings_service_codes' do
    let(:procurement) { create(:facilities_management_rm6232_procurement_results, service_codes:) }
    let(:service_codes) { ['E.1', 'E.2', 'E.3', 'E.4'] }

    before do
      procurement.procurement_buildings.create(active: false, service_codes: service_codes, building: create(:facilities_management_building, user: procurement.user))
      procurement.active_procurement_buildings.first.update(service_codes: ['E.2'])
      procurement.active_procurement_buildings.last.update(service_codes: ['E.4'])
    end

    it 'only uses the service codes in the active procurement buildings' do
      expect(procurement.send(:procurement_buildings_service_codes)).to match_array %w[E.2 E.4]
    end
  end

  describe '.true_procurement_buildings_service_codes' do
    let(:procurement) { create(:facilities_management_rm6232_procurement_results, service_codes:, lot_number:) }
    let(:base_service_codes) { ['E.1', 'E.2', 'F.1', 'F.2', 'H.1'] }
    let(:base_procurement_buildings_service_codes) { ['E.1', 'F.1', 'H.1'] }
    let(:lot_number) { '1a' }

    before { procurement.procurement_buildings.each { |procurement_building| procurement_building.update(service_codes: procurement_buildings_service_codes) } }

    context 'when the service codes contain Q.3' do
      let(:service_codes) { base_service_codes + ['Q.3'] }
      let(:procurement_buildings_service_codes) { base_procurement_buildings_service_codes + ['Q.3'] }

      context 'and the lot is 1a' do
        let(:lot_number) { '1a' }

        it 'returns the services with Q.2 instead of Q.3' do
          expect(procurement.send(:true_procurement_buildings_service_codes)).to eq base_procurement_buildings_service_codes + ['Q.2']
        end
      end

      context 'and the lot is 2a' do
        let(:lot_number) { '2a' }

        it 'returns the services with Q.2 instead of Q.3' do
          expect(procurement.send(:true_procurement_buildings_service_codes)).to eq base_procurement_buildings_service_codes + ['Q.2']
        end
      end

      context 'and the lot is 3a' do
        let(:lot_number) { '3a' }

        it 'returns the services with Q.1 instead of Q.3' do
          expect(procurement.send(:true_procurement_buildings_service_codes)).to eq base_procurement_buildings_service_codes + ['Q.1']
        end
      end

      context 'and the lot is 1b' do
        let(:lot_number) { '1b' }

        it 'returns the services with Q.2 instead of Q.3' do
          expect(procurement.send(:true_procurement_buildings_service_codes)).to eq base_procurement_buildings_service_codes + ['Q.2']
        end
      end

      context 'and the lot is 2b' do
        let(:lot_number) { '2b' }

        it 'returns the services with Q.2 instead of Q.3' do
          expect(procurement.send(:true_procurement_buildings_service_codes)).to eq base_procurement_buildings_service_codes + ['Q.2']
        end
      end

      context 'and the lot is 3b' do
        let(:lot_number) { '3b' }

        it 'returns the services with Q.1 instead of Q.3' do
          expect(procurement.send(:true_procurement_buildings_service_codes)).to eq base_procurement_buildings_service_codes + ['Q.1']
        end
      end

      context 'and the lot is 1c' do
        let(:lot_number) { '1c' }

        it 'returns the services with Q.2 instead of Q.3' do
          expect(procurement.send(:true_procurement_buildings_service_codes)).to eq base_procurement_buildings_service_codes + ['Q.2']
        end
      end

      context 'and the lot is 2c' do
        let(:lot_number) { '2c' }

        it 'returns the services with Q.2 instead of Q.3' do
          expect(procurement.send(:true_procurement_buildings_service_codes)).to eq base_procurement_buildings_service_codes + ['Q.2']
        end
      end

      context 'and the lot is 3c' do
        let(:lot_number) { '3c' }

        it 'returns the services with Q.1 instead of Q.3' do
          expect(procurement.send(:true_procurement_buildings_service_codes)).to eq base_procurement_buildings_service_codes + ['Q.1']
        end
      end
    end

    context 'when the service codes do not contain Q.3' do
      let(:service_codes) { base_service_codes }
      let(:procurement_buildings_service_codes) { base_service_codes }

      it 'returns the service codes unchanged' do
        expect(procurement.send(:true_procurement_buildings_service_codes)).to eq procurement_buildings_service_codes
      end
    end
  end

  describe '.procurement_buildings_region_codes' do
    let(:procurement) { create(:facilities_management_rm6232_procurement_results, region_codes: ['UKI4', 'UKI5']) }

    before do
      procurement.procurement_buildings.create(active: false, service_codes: ['E.1'], building: create(:facilities_management_building, user: procurement.user, address_region_code: 'UKI4'))
      procurement.active_procurement_buildings.first.building.update(address_region_code: 'UKL1')
      procurement.active_procurement_buildings.last.building.update(address_region_code: 'UKM2')
      procurement.send(:freeze_data)
    end

    it 'uses the regions from the active procurement buildings and not the procurement' do
      expect(procurement.send(:procurement_buildings_region_codes)).to match_array %w[UKL1 UKM2]
    end
  end
end
