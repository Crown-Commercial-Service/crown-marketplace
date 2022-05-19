require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Procurement, type: :model do
  it { is_expected.to belong_to(:user) }

  describe '.quick_view_suppliers' do
    let(:procurement) { create(:facilities_management_rm6232_procurement_no_procurement_buildings, service_codes: service_codes) }
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
    let(:procurement) { create(:facilities_management_rm6232_procurement_no_procurement_buildings, service_codes: service_codes, lot_number: lot_number) }
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
    let(:procurement) { create(:facilities_management_rm6232_procurement_no_procurement_buildings) }

    it 'returns an array of FacilitiesManagement::Region' do
      expect(procurement.regions.length).to eq 2
      expect(procurement.regions.first).to be_a FacilitiesManagement::Region
    end
  end

  describe '.service_codes_without_cafm' do
    let(:procurement) { create(:facilities_management_rm6232_procurement_no_procurement_buildings, service_codes: service_codes) }
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
    let(:procurement) { create(:facilities_management_rm6232_procurement_no_procurement_buildings, service_codes: service_codes, lot_number: lot_number) }
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
end
