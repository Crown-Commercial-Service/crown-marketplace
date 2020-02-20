require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementSupplier, type: :model do
  let(:current_year) { Date.current.year.to_s }
  let(:da_current_year_1) { create(:facilities_management_procurement_supplier_da, contract_number: "RM3860-DA0001-#{current_year}") }
  let(:da_current_year_2) { create(:facilities_management_procurement_supplier_da, contract_number: "RM3860-DA0002-#{current_year}") }
  let(:da_previous_year_1) { create(:facilities_management_procurement_supplier_da, contract_number: 'RM3860-DA0003-2019') }
  let(:da_previous_year_2) { create(:facilities_management_procurement_supplier_da, contract_number: 'RM3860-DA0004-2019') }
  let(:fc_current_year_1) { create(:facilities_management_procurement_supplier_fc, contract_number: "RM3860-FC005-#{current_year}") }
  let(:fc_current_year_2) { create(:facilities_management_procurement_supplier_fc, contract_number: "RM3860-FC006-#{current_year}") }
  let(:fc_previous_year_1) { create(:facilities_management_procurement_supplier_fc, contract_number: 'RM3860-FC007-2019') }
  let(:fc_previous_year_2) { create(:facilities_management_procurement_supplier_fc, contract_number: 'RM3860-FC008-2019') }

  before do
    da_current_year_1
    da_current_year_2
    da_previous_year_1
    da_previous_year_2
    fc_current_year_1
    fc_current_year_2
    fc_previous_year_1
    fc_previous_year_2
  end

  describe '.used_direct_award_contract_numbers_for_current_year' do
    it 'presents all of the direct award contract numbers used for the current year' do
      expect(described_class.used_direct_award_contract_numbers_for_current_year).to match(['0001', '0002'])
    end

    it 'does not present any of the direct award contract numbers used for the previous years' do
      expect(described_class.used_direct_award_contract_numbers_for_current_year).not_to match(['0003', '0004'])
    end
  end

  describe '.used_further_competition_contract_numbers_for_current_year' do
    it 'presents all of the further competition contract numbers used for the current year' do
      expect(described_class.used_further_competition_contract_numbers_for_current_year).to match(['005', '006'])
    end

    it 'does not present any of the further competition contract numbers used for the previous years' do
      expect(described_class.used_further_competition_contract_numbers_for_current_year).not_to match(['0007', '0008'])
    end
  end

  describe '.generate_contract_number' do
    let(:direct_award) { create(:facilities_management_procurement_supplier_da) }
    let(:further_competition) { create(:facilities_management_procurement_supplier_fc) }
    let(:number_array) { (1..9999).map { |integer| format('%04d', integer % 10000) } }
    let(:expected_number) { number_array.sample }

    let(:number_array_fc) { (1..999).map { |integer| format('%03d', integer % 10000) } }
    let(:expected_number_fc) { number_array_fc.sample }

    before do
      allow(described_class).to receive(:used_direct_award_contract_numbers_for_current_year) { number_array - [expected_number] }
      allow(described_class).to receive(:used_further_competition_contract_numbers_for_current_year) { number_array_fc - [expected_number_fc] }
    end

    context 'with a procurement in direct award' do
      it 'returns an available number for a direct award contract' do
        expect(direct_award.send(:generate_contract_number)).to eq("RM3830-DA#{expected_number}-#{current_year}")
      end
    end

    context 'with a procurement in direct award' do
      it 'returns an available number for a further competition contract' do
        expect(further_competition.send(:generate_contract_number)).to eq("RM3830-FC#{expected_number_fc}-#{current_year}")
      end
    end
  end
end
