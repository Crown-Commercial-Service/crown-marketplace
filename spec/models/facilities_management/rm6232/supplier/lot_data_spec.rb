require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Supplier::LotData do
  let(:lot_data) { described_class.where(facilities_management_rm6232_supplier_id: supplier_id).find_by(lot_code: lot_code) }
  let(:random_lot_data) { described_class.order(Arel.sql('RANDOM()')).first }

  describe '.supplier_name' do
    it 'returns the suppleirs name from the supplier model' do
      supplier_name = FacilitiesManagement::RM6232::Supplier.find(random_lot_data.facilities_management_rm6232_supplier_id).supplier_name

      expect(random_lot_data.supplier_name).to eq supplier_name
    end
  end

  describe '.services' do
    let(:lot_code) { '1a' }
    let(:random_lot_data) { described_class.where(lot_code: lot_code).order(Arel.sql('RANDOM()')).first }

    it 'returns a collection of services' do
      expect(random_lot_data.services.class.to_s).to eq 'FacilitiesManagement::RM6232::Service::ActiveRecord_Relation'
    end

    context 'when the lot is 1a' do
      it 'has all the core total services' do
        total_core_services = %w[E.1 E.2 E.3 E.4 E.5 E.6 E.7 E.8 E.10 E.11 E.12 E.13 F.1 F.2 F.3 F.7 F.8 F.10 F.11 F.13 G.1 G.2 G.4 G.5 H.2 H.3 H.5 H.9 I.1 I.2 I.5 I.6 I.7 I.8 I.16 J.1 J.2 J.3 J.4 J.6 J.13 K.1 L.1 L.2 L.3 L.4 L.5 L.6 L.7 L.8 L.11 L.13 L.15 M.1 M.2 M.3 M.4 M.8 Q.2 R.1 S.1]

        expect(total_core_services - random_lot_data.service_codes).to be_empty
      end
    end

    context 'when the lot is 2a' do
      let(:lot_code) { '2a' }

      it 'has all the core total services' do
        hard_core_services = %w[E.1 E.2 E.3 E.4 E.5 E.6 E.7 E.8 E.10 E.11 E.12 E.13 F.1 F.2 F.3 F.7 F.8 F.10 F.11 F.13 Q.2 R.1 S.1]

        expect(hard_core_services - random_lot_data.service_codes).to be_empty
      end
    end

    context 'when the lot is 3a' do
      let(:lot_code) { '3a' }

      it 'has all the core total services' do
        soft_core_services = %w[G.1 G.2 G.4 G.5 H.2 H.3 H.5 H.9 I.1 I.2 I.5 I.6 I.7 I.8 I.16 J.1 J.2 J.3 J.4 J.6 J.13 K.1 L.1 L.2 L.3 L.4 L.5 L.6 L.7 L.8 L.11 L.13 L.15 M.1 M.2 M.3 M.4 M.8 Q.1 R.1 S.1]

        expect(soft_core_services - random_lot_data.service_codes).to be_empty
      end
    end
  end

  describe '.regions' do
    let(:result) { lot_data.regions.map(&:code) }

    it 'returns a collection of regions' do
      expect(random_lot_data.regions.first.class).to eq FacilitiesManagement::Region
    end

    it 'has at least one reagion' do
      expect(random_lot_data.region_codes.count).to be >= 1
    end
  end

  describe 'validations' do
    context 'when validating the lot status' do
      let(:lot_data) { create(:facilities_management_rm6232_supplier_lot_data, :with_supplier, active: active) }

      context 'and active is nil' do
        let(:active) { nil }

        it 'is not valid and has the correct error message' do
          expect(lot_data).not_to be_valid(:lot_status)
          expect(lot_data.errors[:active].first).to eq 'You must select a status for the lot data'
        end
      end

      context 'and active is blank' do
        let(:active) { '' }

        it 'is not valid and has the correct error message' do
          expect(lot_data).not_to be_valid(:lot_status)
          expect(lot_data.errors[:active].first).to eq 'You must select a status for the lot data'
        end
      end

      context 'and active is true' do
        let(:active) { 'true' }

        it 'is valid' do
          expect(lot_data).to be_valid(:lot_status)
        end
      end

      context 'and active is false' do
        let(:active) { 'false' }

        it 'is valid' do
          expect(lot_data).to be_valid(:lot_status)
        end
      end
    end

    context 'when validating the region codes' do
      let(:lot_data) { create(:facilities_management_rm6232_supplier_lot_data, :with_supplier, region_codes: region_codes) }

      context 'and there are none' do
        let(:region_codes) { [] }

        it 'is not valid and has the correct error message' do
          expect(lot_data.valid?(:region_codes)).to be false
          expect(lot_data.errors[:region_codes].first).to eq 'You must select at least one region for this lot'
        end
      end

      context 'and there are some' do
        let(:region_codes) { %w[UKC1 UKC2] }

        it 'is valid' do
          expect(lot_data.valid?(:region_codes)).to be true
        end
      end
    end
  end

  describe '.changed_data' do
    let(:lot_data) { create(:facilities_management_rm6232_supplier_lot_data, :with_supplier) }
    let(:supplier) { lot_data.supplier }
    let(:result) { lot_data.changed_data }

    before { lot_data.update(attributes) }

    context 'when changing the status' do
      let(:attributes) { { active: false } }
      let(:data) do
        {
          attribute: 'active',
          lot_code: '1a',
          added: false,
          removed: true
        }
      end

      it 'returns the correct data' do
        expect(result).to eq([supplier.id, :lot_data, data])
      end
    end

    context 'when changing the services' do
      let(:attributes) { { service_codes: service_codes } }

      context 'and a service is added' do
        let(:service_codes) { %w[E.16 H.6 P.11 F.4] }
        let(:data) do
          {
            attribute: 'service_codes',
            lot_code: '1a',
            added: %w[F.4],
            removed: []
          }
        end

        it 'returns the correct data' do
          expect(result).to eq([supplier.id, :lot_data, data])
        end
      end

      context 'and a service is removed' do
        let(:service_codes) { %w[E.16 P.11] }
        let(:data) do
          {
            attribute: 'service_codes',
            lot_code: '1a',
            added: [],
            removed: %w[H.6]
          }
        end

        it 'returns the correct data' do
          expect(result).to eq([supplier.id, :lot_data, data])
        end
      end

      context 'and one service is added and one removed' do
        let(:service_codes) { %w[E.16 P.11 F.4] }
        let(:data) do
          {
            attribute: 'service_codes',
            lot_code: '1a',
            added: %w[F.4],
            removed: %w[H.6]
          }
        end

        it 'returns the correct data' do
          expect(result).to eq([supplier.id, :lot_data, data])
        end
      end
    end

    context 'when changing the regions' do
      let(:attributes) { { region_codes: region_codes } }

      context 'and a region is added' do
        let(:region_codes) { %w[UKC1 UKD1 UKE1 UKF1] }
        let(:data) do
          {
            attribute: 'region_codes',
            lot_code: '1a',
            added: %w[UKF1],
            removed: []
          }
        end

        it 'returns the correct data' do
          expect(result).to eq([supplier.id, :lot_data, data])
        end
      end

      context 'and a region is removed' do
        let(:region_codes) { %w[UKC1 UKE1] }
        let(:data) do
          {
            attribute: 'region_codes',
            lot_code: '1a',
            added: [],
            removed: %w[UKD1]
          }
        end

        it 'returns the correct data' do
          expect(result).to eq([supplier.id, :lot_data, data])
        end
      end

      context 'and one region is added and one removed' do
        let(:region_codes) { %w[UKC1 UKE1 UKF1] }
        let(:data) do
          {
            attribute: 'region_codes',
            lot_code: '1a',
            added: %w[UKF1],
            removed: %w[UKD1]
          }
        end

        it 'returns the correct data' do
          expect(result).to eq([supplier.id, :lot_data, data])
        end
      end
    end
  end

  describe '.current_status' do
    let(:lot_data) { create(:facilities_management_rm6232_supplier_lot_data, :with_supplier, active: active) }

    context 'when the lot data is active' do
      let(:active) { true }

      it 'returns blue and ACTIVE' do
        expect(lot_data.current_status).to eq [:blue, 'ACTIVE']
      end
    end

    context 'when the lot data is not active' do
      let(:active) { false }

      it 'returns red and INACTIVE' do
        expect(lot_data.current_status).to eq [:red, 'INACTIVE']
      end
    end
  end
end
