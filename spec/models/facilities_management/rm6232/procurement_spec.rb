require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Procurement, type: :model do
  it { is_expected.to belong_to(:user) }

  describe '.quick_view_suppliers' do
    let(:procurement) { build(:facilities_management_rm6232_procurement_no_procurement_buildings, service_codes: service_codes) }
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

  describe '.services' do
    let(:procurement) { build(:facilities_management_rm6232_procurement_what_happens_next, service_codes: service_codes, lot_number: lot_number) }
    let(:base_service_codes) { ['E.1', 'E.2'] }
    let(:service_codes) { base_service_codes }
    let(:lot_number) { '1a' }

    it 'returns an array of FacilitiesManagement::RM6232::Service' do
      expect(procurement.services.length).to eq 2
      expect(procurement.services.first).to be_a FacilitiesManagement::RM6232::Service
    end

    context 'when the service codes contain Q.3' do
      let(:service_codes) { base_service_codes + ['Q.3'] }
      let(:service_Q1) { FacilitiesManagement::RM6232::Service.find('Q.1') }
      let(:service_Q2) { FacilitiesManagement::RM6232::Service.find('Q.2') }
      let(:service_Q3) { FacilitiesManagement::RM6232::Service.find('Q.3') }

      context 'and it is a total sub lot' do
        let(:lot_number) { '1a' }

        it 'returns services with Q.2 instead of Q.3' do
          expect(procurement.services).not_to include service_Q3
          expect(procurement.services).to include service_Q2
        end
      end

      context 'and it is a hard sub lot' do
        let(:lot_number) { '2a' }

        it 'returns services with Q.2 instead of Q.3' do
          expect(procurement.services).not_to include service_Q3
          expect(procurement.services).to include service_Q2
        end
      end

      context 'and it is a soft sub lot' do
        let(:lot_number) { '3a' }

        it 'returns services with Q.1 instead of Q.3' do
          expect(procurement.services).not_to include service_Q3
          expect(procurement.services).to include service_Q1
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
    let(:procurement) { build(:facilities_management_rm6232_procurement_what_happens_next, service_codes: service_codes) }
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
    let(:procurement) { build(:facilities_management_rm6232_procurement_what_happens_next, service_codes: service_codes, lot_number: lot_number) }
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
      before { procurement.set_to_next_state }

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
      end

      context 'and the state is results' do
        let(:state) { 'results' }

        it 'changes the state to further_competition' do
          expect(procurement.further_competition?).to be true
        end
      end
    end
  end

  describe 'scope' do
    before do
      create(:facilities_management_rm6232_procurement_what_happens_next, aasm_state: 'what_happens_next', contract_name: 'WHN procurement 1')
      create(:facilities_management_rm6232_procurement_what_happens_next, aasm_state: 'results', contract_name: 'R procurement 1')
      create(:facilities_management_rm6232_procurement_what_happens_next, aasm_state: 'further_competition', contract_name: 'FC procurement 1')
      create(:facilities_management_rm6232_procurement_what_happens_next, aasm_state: 'what_happens_next', contract_name: 'WHN procurement 2')
      create(:facilities_management_rm6232_procurement_what_happens_next, aasm_state: 'entering_requirements', contract_name: 'ER procurement 1')
      create(:facilities_management_rm6232_procurement_what_happens_next, aasm_state: 'further_competition', contract_name: 'FC procurement 2')
    end

    context 'when the searches scope is called' do
      it 'returns the epxected procurements in the right order' do
        searches = described_class.searches

        expect(searches.length).to eq 4
        expect(searches.map(&:contract_name)).to eq ['WHN procurement 1', 'WHN procurement 2', 'ER procurement 1', 'R procurement 1']
      end

      it 'has the right data' do
        expect(described_class.searches.first.attributes.keys).to eq(%w[id aasm_state contract_name updated_at])
      end
    end

    context 'when the advanced_procurement_activities scope is called' do
      it 'returns the epxected procurements in the right order' do
        advanced_procurement_activities = described_class.advanced_procurement_activities

        expect(advanced_procurement_activities.length).to eq 2
        expect(advanced_procurement_activities.map(&:contract_name)).to eq ['FC procurement 1', 'FC procurement 2']
      end

      it 'has the right data' do
        expect(described_class.advanced_procurement_activities.first.attributes.keys).to eq(%w[id contract_name updated_at contract_number])
      end
    end
  end

  describe '.contract_name_status' do
    subject(:status) { procurement.contract_name_status }

    let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, contract_name: contract_name) }

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

    let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, annual_contract_value: annual_contract_value) }

    context 'when the annual contract value section has not been completed' do
      let(:annual_contract_value) { nil }

      it 'has a status of not_started' do
        expect(status).to eq(:not_started)
      end
    end

    context 'when the annual contract value section has been completed' do
      let(:annual_contract_value) { 123_456 }

      it 'has a status of completed' do
        expect(status).to eq(:completed)
      end
    end
  end

  describe '.tupe_status' do
    subject(:status) { procurement.tupe_status }

    let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, tupe: tupe) }

    context 'when the tupe section has not been completed' do
      let(:tupe) { nil }

      pending 'has a status of not_started' do
        expect(status).to eq(:not_started)
      end
    end

    context 'when the tupe section has been completed' do
      let(:tupe) { true }

      pending 'has a status of completed' do
        expect(status).to eq(:completed)
      end
    end
  end

  describe '.contract_period_status' do
    subject(:status) { procurement.contract_period_status }

    context 'when all contract period sections have not been started' do
      let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, initial_call_off_period_years: nil, initial_call_off_period_months: nil, initial_call_off_start_date: nil, mobilisation_period_required: nil, extensions_required: nil) }

      pending 'has a status of not_started' do
        expect(status).to eq(:not_started)
      end
    end

    context 'when all contract period sections have not been completed' do
      let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, initial_call_off_period_months: nil, mobilisation_period_required: false, extensions_required: false) }

      pending 'has a status of not_started' do
        expect(status).to eq(:incomplete)
      end
    end

    context 'when all contract period sections have been completed' do
      let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, mobilisation_period_required: false, extensions_required: false) }

      pending 'has a status of completed' do
        expect(status).to eq(:completed)
      end
    end
  end

  describe '.services_status' do
    subject(:status) { procurement.services_status }

    let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, service_codes: service_codes) }

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
      let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements) }

      pending 'shown with the COMPLETED status label' do
        expect(status).to eq(:completed)
      end
    end
  end

  shared_context 'with buildings and services' do
    let(:procurement) do
      create(:facilities_management_rm6232_procurement_entering_requirements, procurement_buildings: procurement_buildings)
    end

    let(:procurement_buildings) { [procurement_building1, procurement_building2] }

    let(:procurement_building1) { build(:facilities_management_rm6232_procurement_building) }
    let(:procurement_building2) { build(:facilities_management_rm6232_procurement_building) }
  end

  describe '.buildings_and_services_completed' do
    include_context 'with buildings and services'

    before do
      procurement_building1.update(service_codes: service_codes)
      procurement_building2.update(service_codes: %w[E.1 E.2])
    end

    context 'when one building has no service codes' do
      let(:service_codes) { [] }

      pending 'returns false' do
        expect(procurement.buildings_and_services_completed?).to eq false
      end
    end

    context 'when one building has an invalid selection' do
      let(:service_codes) { %w[Q.3 R.1 S.1] }

      pending 'returns false' do
        expect(procurement.buildings_and_services_completed?).to eq false
      end
    end

    context 'when both buildings have a valid selection' do
      let(:service_codes) { %w[Q.3 R.1 S.1 E.1] }

      pending 'returns true' do
        expect(procurement.buildings_and_services_completed?).to eq true
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

      pending 'shown with the CANNOT START YET status label' do
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
          procurement_building1.procurement_building_services.delete_all
          procurement_building2.procurement_building_services.delete_all
        end

        pending 'shown with the NOT STARTED status label' do
          expect(status).to eq(:incomplete)
        end
      end

      context 'when at least one service is assigned to each and every building' do
        before do
          procurement_building1.update(service_codes: ['E.1'])
          procurement_building2.update(service_codes: ['F.1', 'G.4', 'R.1'])
        end

        pending 'shown with the COMPLETED status label' do
          expect(status).to eq(:completed)
        end
      end
    end
  end
end
