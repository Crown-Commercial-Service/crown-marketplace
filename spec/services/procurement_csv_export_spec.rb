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
      supplier = create(:facilities_management_supplier_detail)
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
    subject(:row) { described_class.create_contract_row(procurement_in_da.procurement_suppliers.first) }

    it 'produces correct number of elements' do
      expect(row.size).to eq described_class::COLUMN_LABELS.size
    end
  end

  describe '.create_procurement_row' do
    subject(:row) { described_class.create_procurement_row(procurement_in_search) }

    it 'produces correct number of elements' do
      expect(row.size).to eq described_class::COLUMN_LABELS.size
    end
  end

  describe '.estimated_annual_cost' do
    before do
      procurement_in_search.update(estimated_cost_known: known, estimated_annual_cost: 100)
    end

    context 'when not filled in yet' do
      let(:known) { nil }

      it 'show blank' do
        expect(described_class.estimated_annual_cost(procurement_in_search)).to be_blank
      end
    end

    context 'when known' do
      let(:known) { true }

      it 'show value' do
        expect(described_class.estimated_annual_cost(procurement_in_search)).to eq '100.00'
      end
    end

    context 'when not known' do
      let(:known) { false }

      it 'show "None"' do
        expect(described_class.estimated_annual_cost(procurement_in_search)).to eq 'None'
      end
    end
  end

  describe '.mobilisation_period' do
    let(:period) { 10 }
    let(:initial_call_off_start_date) { Date.new(2019, 6, 6) }

    before do
      procurement_in_search.update(
        mobilisation_period_required: required,
        mobilisation_period: period,
        initial_call_off_start_date: initial_call_off_start_date
      )
    end

    context 'when not filled in yet' do
      let(:required) { nil }

      it 'show blank' do
        expect(described_class.mobilisation_period(procurement_in_search)).to be_blank
      end
    end

    context 'when required' do
      let(:required) { true }

      it 'show period and date range' do
        expect(described_class.mobilisation_period(procurement_in_search)).to eq '10 weeks, 27 March 2019 -  5 June 2019'
      end

      context 'with no mobilisation period' do
        let(:period) { nil }

        it 'show "None"' do
          expect(described_class.mobilisation_period(procurement_in_search)).to eq 'None'
        end
      end
    end

    context 'when not required' do
      let(:required) { false }

      it 'show "None"' do
        expect(described_class.mobilisation_period(procurement_in_search)).to eq 'None'
      end
    end
  end

  describe '.call_off_extensions' do
    before do
      procurement_in_search.update(extensions_required: required)

      4.times do |extension|
        procurement_in_search.optional_call_off_extensions.create(extension: extension, years: (extension + 1) % 4, months: extension * 2)
      end
    end

    context 'when not filled in yet' do
      let(:required) { nil }

      it 'show blank' do
        expect(described_class.call_off_extensions(procurement_in_search)).to be_blank
      end
    end

    context 'when required' do
      let(:required) { true }

      it 'show extensions' do
        expect(described_class.call_off_extensions(procurement_in_search)).to eq '4 extensions, 1 year, 2 years and 2 months, 3 years and 4 months, 6 months'
      end
    end

    context 'when not required' do
      let(:required) { false }

      it 'show "None"' do
        expect(described_class.call_off_extensions(procurement_in_search)).to eq 'None'
      end
    end
  end

  describe '.localised_datetime' do
    it 'applies DST correctly' do
      expect(described_class.localised_datetime(DateTime.parse('7 Jan 2005 08:09:00+00:00'))).to eq ' 7 January 2005,  8:09am'
      expect(described_class.localised_datetime(DateTime.parse('7 Jun 2005 08:09:00+00:00'))).to eq ' 7 June 2005,  9:09am'
    end
  end
end
