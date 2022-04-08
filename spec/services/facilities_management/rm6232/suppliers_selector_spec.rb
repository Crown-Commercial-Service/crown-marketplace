require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::SuppliersSelector do
  subject(:suppliers_selector) { described_class.new(service_codes[..-3], region_codes[..2], annual_contract_value) }

  let(:lot_number) { suppliers_selector.lot_number }
  let(:supplier_names) { suppliers_selector.selected_suppliers.map(&:supplier_name) }

  let!(:my_supplier) do
    create(:facilities_management_rm6232_supplier) do |supplier|
      supplier.lot_data = build_list(:facilities_management_rm6232_supplier_lot_data, 1, lot_code: lot_code, service_codes: supplier_services, region_codes: supplier_regions)
    end
  end

  let(:selection_one) { { total: false, hard: false, soft: false } }
  let(:selection_two) { { total: false, hard: false, soft: false } }
  let(:service_codes) { FacilitiesManagement::RM6232::Service.where(**selection_one).sample(5).pluck(:code) + FacilitiesManagement::RM6232::Service.where(**selection_two).sample(5).pluck(:code) }
  let(:region_codes) { FacilitiesManagement::Region.all[..-2].sample(5).map(&:code) }
  let(:supplier_services) { service_codes }
  let(:supplier_regions) { region_codes }

  describe 'lot number and selected suppliers' do
    context 'when all services are hard' do
      let(:selection_one) { { total: true, hard: true, soft: false } }

      context 'and the annual_contract_value is less than 1,500,000' do
        let(:lot_code) { 'a' }
        let(:annual_contract_value) { rand(1_500_000) }

        it 'returns 2a for the lot number' do
          expect(lot_number).to eq '2a'
        end

        it 'returns a list of suppliers that includes my_supplier' do
          expect(supplier_names).to include my_supplier.supplier_name
        end
      end

      context 'and the annual_contract_value is a more than 1,500,000 and less than 10,000,000' do
        let(:lot_code) { 'b' }
        let(:annual_contract_value) { rand(1_500_000...10_000_000) }

        it 'returns 2b for the lot number' do
          expect(lot_number).to eq '2b'
        end

        it 'returns a list of suppliers that includes my_supplier' do
          expect(supplier_names).to include my_supplier.supplier_name
        end
      end

      context 'and the annual_contract_value is more than 10,000,000' do
        let(:lot_code) { 'c' }
        let(:annual_contract_value) { rand(10_000_000...50_000_000) }

        it 'returns 2c for the lot number' do
          expect(lot_number).to eq '2c'
        end

        it 'returns a list of suppliers that includes my_supplier' do
          expect(supplier_names).to include my_supplier.supplier_name
        end
      end
    end

    context 'when all services are soft' do
      let(:selection_one) { { total: true, hard: false, soft: true } }

      context 'and the annual_contract_value is less than 1,000,000' do
        let(:lot_code) { 'a' }
        let(:annual_contract_value) { rand(1_000_000) }

        it 'returns 3a for the lot number' do
          expect(lot_number).to eq '3a'
        end

        it 'returns a list of suppliers that includes my_supplier' do
          expect(supplier_names).to include my_supplier.supplier_name
        end
      end

      context 'and the annual_contract_value is a more than 1,000,000 and less than 7,000,000' do
        let(:lot_code) { 'b' }
        let(:annual_contract_value) { rand(1_000_000...7_000_000) }

        it 'returns 3b for the lot number' do
          expect(lot_number).to eq '3b'
        end

        it 'returns a list of suppliers that includes my_supplier' do
          expect(supplier_names).to include my_supplier.supplier_name
        end
      end

      context 'and the annual_contract_value is more than 7,000,000' do
        let(:lot_code) { 'c' }
        let(:annual_contract_value) { rand(7_000_000...50_000_000) }

        it 'returns 3c for the lot number' do
          expect(lot_number).to eq '3c'
        end

        it 'returns a list of suppliers that includes my_supplier' do
          expect(supplier_names).to include my_supplier.supplier_name
        end
      end
    end

    context 'when there are a mix of hard and soft' do
      let(:selection_one) { { total: true, hard: true, soft: false } }
      let(:selection_two) { { total: true, hard: false, soft: true } }

      context 'and the annual_contract_value is less than 1,500,000' do
        let(:lot_code) { 'a' }
        let(:annual_contract_value) { rand(1_500_000) }

        it 'returns 1a for the lot number' do
          expect(lot_number).to eq '1a'
        end

        it 'returns a list of suppliers that includes my_supplier' do
          expect(supplier_names).to include my_supplier.supplier_name
        end
      end

      context 'and the annual_contract_value is a more than 1,500,000 and less than 10,000,000' do
        let(:lot_code) { 'b' }
        let(:annual_contract_value) { rand(1_500_000...10_000_000) }

        it 'returns 1b for the lot number' do
          expect(lot_number).to eq '1b'
        end

        it 'returns a list of suppliers that includes my_supplier' do
          expect(supplier_names).to include my_supplier.supplier_name
        end
      end

      context 'and the annual_contract_value is more than 10,000,000' do
        let(:lot_code) { 'c' }
        let(:annual_contract_value) { rand(10_000_000...50_000_000) }

        it 'returns 1c for the lot number' do
          expect(lot_number).to eq '1c'
        end

        it 'returns a list of suppliers that includes my_supplier' do
          expect(supplier_names).to include my_supplier.supplier_name
        end
      end
    end

    context 'when my_supplier does not provide the lot' do
      let(:lot_code) { 'b' }
      let(:annual_contract_value) { rand(1_000_000) }

      context 'when Total FM services are selected' do
        let(:selection_one) { { total: true, hard: true, soft: false } }
        let(:selection_two) { { total: true, hard: false, soft: true } }

        it 'returns a list of suppliers that does not include my_supplier' do
          expect(lot_number).to eq '1a'
          expect(supplier_names).not_to include my_supplier.supplier_name
        end
      end

      context 'when Hard FM services are selected' do
        let(:selection_one) { { total: true, hard: true, soft: false } }

        it 'returns a list of suppliers that does not include my_supplier' do
          expect(lot_number).to eq '2a'
          expect(supplier_names).not_to include my_supplier.supplier_name
        end
      end

      context 'when Soft FM services are selected' do
        let(:selection_one) { { total: true, hard: false, soft: true } }

        it 'returns a list of suppliers that does not include my_supplier' do
          expect(lot_number).to eq '3a'
          expect(supplier_names).not_to include my_supplier.supplier_name
        end
      end
    end

    context 'when my_supplier does not provide all the services' do
      let(:lot_code) { 'a' }
      let(:annual_contract_value) { rand(1_500_000) }
      let(:supplier_services) { service_codes[..-4] }
      let(:supplier_regions) { region_codes }

      context 'when Total FM services are selected' do
        let(:selection_one) { { total: true, hard: true, soft: false } }
        let(:selection_two) { { total: true, hard: false, soft: true } }

        it 'returns a list of suppliers that does not include my_supplier' do
          expect(supplier_names).not_to include my_supplier.supplier_name
        end
      end

      context 'when Hard FM services are selected' do
        let(:selection_one) { { total: true, hard: true, soft: false } }

        it 'returns a list of suppliers that does not include my_supplier' do
          expect(supplier_names).not_to include my_supplier.supplier_name
        end
      end

      context 'when Soft FM services are selected' do
        let(:selection_one) { { total: true, hard: false, soft: true } }

        it 'returns a list of suppliers that does not include my_supplier' do
          expect(supplier_names).not_to include my_supplier.supplier_name
        end
      end
    end

    context 'when my_supplier does not provide for all the regions' do
      let(:lot_code) { 'a' }
      let(:annual_contract_value) { rand(1_500_000) }
      let(:supplier_services) { service_codes }
      let(:supplier_regions) { region_codes[-3..] }

      context 'when Total FM services are selected' do
        let(:selection_one) { { total: true, hard: true, soft: false } }
        let(:selection_two) { { total: true, hard: false, soft: true } }

        it 'returns a list of suppliers that does not include my_supplier' do
          expect(supplier_names).not_to include my_supplier.supplier_name
        end
      end

      context 'when Hard FM services are selected' do
        let(:selection_one) { { total: true, hard: true, soft: false } }

        it 'returns a list of suppliers that does not include my_supplier' do
          expect(supplier_names).not_to include my_supplier.supplier_name
        end
      end

      context 'when Soft FM services are selected' do
        let(:selection_one) { { total: true, hard: false, soft: true } }

        it 'returns a list of suppliers that does not include my_supplier' do
          expect(supplier_names).not_to include my_supplier.supplier_name
        end
      end
    end
  end
end
