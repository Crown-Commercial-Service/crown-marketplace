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
    let(:procurement) { build(:facilities_management_rm6232_procurement_no_procurement_buildings, service_codes: service_codes, lot_number: lot_number) }
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
    let(:procurement) { build(:facilities_management_rm6232_procurement_no_procurement_buildings) }

    it 'returns an array of FacilitiesManagement::Region' do
      expect(procurement.regions.length).to eq 2
      expect(procurement.regions.first).to be_a FacilitiesManagement::Region
    end
  end

  describe '.service_codes_without_cafm' do
    let(:procurement) { build(:facilities_management_rm6232_procurement_no_procurement_buildings, service_codes: service_codes) }
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
    let(:procurement) { build(:facilities_management_rm6232_procurement_no_procurement_buildings, service_codes: service_codes, lot_number: lot_number) }
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

  describe 'validations' do
    describe '#contract_name' do
      let(:procurement) { build(:facilities_management_rm6232_procurement_no_procurement_buildings, :skip_before_create, user: user) }
      let(:user) { create(:user) }

      before { procurement.contract_name = contract_name }

      context 'when the name is more than 100 characters' do
        let(:contract_name) { (0...101).map { ('a'..'z').to_a.sample }.join }

        it 'is expected to not be valid and has the correct error message' do
          expect(procurement.valid?(:contract_name)).to eq false
          expect(procurement.errors[:contract_name].first).to eq 'Your contract name must be 100 characters or fewer'
        end
      end

      context 'when the name is nil' do
        let(:contract_name) { nil }

        it 'is expected to not be valid and has the correct error message' do
          expect(procurement.valid?(:contract_name)).to eq false
          expect(procurement.errors[:contract_name].first).to eq 'Enter your contract name'
        end
      end

      context 'when the name is empty' do
        let(:contract_name) { '' }

        it 'is expected to not be valid and has the correct error message' do
          expect(procurement.valid?(:contract_name)).to eq false
          expect(procurement.errors[:contract_name].first).to eq 'Enter your contract name'
        end
      end

      context 'when the name is taken by the same user' do
        let(:contract_name) { 'My taken name' }

        it 'is expected to not be valid and has the correct error message' do
          create(:facilities_management_rm6232_procurement_no_procurement_buildings, :skip_before_create, user: user, contract_name: contract_name)

          expect(procurement.valid?(:contract_name)).to eq false
          expect(procurement.errors[:contract_name].first).to eq 'This contract name is already in use'
        end
      end

      context 'when the name is taken by the a different user' do
        let(:contract_name) { 'My taken name' }

        it 'is valid' do
          create(:facilities_management_rm6232_procurement_no_procurement_buildings, :skip_before_create, user: create(:user), contract_name: contract_name)

          expect(procurement.valid?(:contract_name)).to eq true
        end
      end

      context 'when the name is correct' do
        let(:contract_name) { 'Valid Name' }

        it 'expected to be valid' do
          expect(procurement.valid?(:contract_name)).to eq true
        end
      end
    end
  end

  describe 'before_create' do
    context 'when a procurement is created' do
      let(:procurement) { build(:facilities_management_rm6232_procurement_no_procurement_buildings, lot_number: nil) }

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
    let(:procurement) { build(:facilities_management_rm6232_procurement_no_procurement_buildings) }

    it 'sets the initial aasm state to what_happens_next' do
      expect(procurement.what_happens_next?).to be true
    end
  end
end
