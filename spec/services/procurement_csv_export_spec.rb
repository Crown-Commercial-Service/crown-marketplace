require 'rails_helper'

RSpec.describe ProcurementCsvExport do
  let!(:procurement_in_search) do
    proc = create(:facilities_management_procurement)
    proc.user.buyer_detail = build(:buyer_detail)
    proc.reload
  end

  let!(:procurement_in_results) { create(:facilities_management_procurement_direct_award, aasm_state: 'results') }

  let(:start_date) { Time.zone.today - 1 }
  let(:end_date) { Time.zone.today + 1 }

  # rubocop:disable Rails/SkipsModelValidations
  let!(:procurement_in_da) do
    proc = create(:facilities_management_procurement_with_contact_details)

    proc.procurement_suppliers.each do |contract|
      supplier = create(:ccs_fm_supplier)
      contract.update(aasm_state: 'sent', supplier_id: supplier.id)
    end

    proc.user.buyer_detail = build(:buyer_detail)
    proc.reload
  end

  let!(:procurement_in_closed) do
    proc = create(:facilities_management_procurement_with_contact_details)
    proc.update_attribute(:aasm_state, 'closed')
    proc.procurement_suppliers.first.update_attribute(:aasm_state, 'sent')
    proc.reload
  end
  # rubocop:enable Rails/SkipsModelValidations

  describe '.find_procurements' do
    subject(:found_procurements) { described_class.find_procurements(start_date, end_date) }

    describe 'Procurement' do
      context 'with no contracts' do
        it 'includes procurement' do
          expect(found_procurements).to include(procurement_in_search)
        end
      end

      context 'with only unsent contracts' do
        it 'includes procurement' do
          expect(found_procurements).to include(procurement_in_results)
        end
      end

      context 'with sent contract' do
        it 'excludes procurement' do
          expect(found_procurements).not_to include(procurement_in_da)
        end
      end
    end

    context 'with dates before last update' do
      let(:start_date) { Time.zone.today - 5 }
      let(:end_date) { Time.zone.today - 3 }

      it 'finds no procurements' do
        expect(found_procurements).to be_none
      end
    end
  end

  describe '.find_contracts' do
    subject(:found_contracts) { described_class.find_contracts(start_date, end_date) }

    describe 'Procurement' do
      context 'with no contracts' do
        it 'excludes procurement' do
          expect(found_contracts.map(&:procurement)).not_to include(procurement_in_search)
        end
      end

      context 'with only unsent contracts' do
        it 'excludes procurement' do
          expect(found_contracts.map(&:procurement)).not_to include(procurement_in_results)
        end
      end

      context 'with sent contract' do
        it 'includes procurement' do
          expect(found_contracts.map(&:procurement)).to include(procurement_in_da)
        end
      end

      context 'with sent contract but closed' do
        it 'includes procurement' do
          expect(found_contracts.map(&:procurement)).to include(procurement_in_closed)
        end
      end
    end

    context 'with dates before last update' do
      let(:start_date) { Time.zone.today - 5 }
      let(:end_date) { Time.zone.today - 3 }

      it 'finds no contracts' do
        expect(found_contracts).to be_none
      end
    end
  end

  describe '.create_contract_row' do
    it 'produces correct number of elements' do
      expect(described_class.create_contract_row(procurement_in_da.procurement_suppliers.first).size).to eq 37
    end
  end

  describe '.create_procurement_row' do
    it 'produces correct number of elements' do
      expect(described_class.create_procurement_row(procurement_in_search).size).to eq 37
    end
  end

  # rubocop:disable Rails/TimeZone
  describe '.localised_datetime' do
    it 'applies DST correctly' do
      expect(described_class.localised_datetime(DateTime.parse('7 Jan 2005 08:09:00+00:00'))).to eq ' 7 January 2005,  8:09am'
      expect(described_class.localised_datetime(DateTime.parse('7 Jun 2005 08:09:00+00:00'))).to eq ' 7 June 2005,  9:09am'
    end
  end
  # rubocop:enable Rails/TimeZone
end
