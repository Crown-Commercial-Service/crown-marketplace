require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Admin::FilesImporter do
  let(:upload) do
    create(:facilities_management_rm6232_admin_upload, aasm_state: 'in_progress') do |admin_upload|
      admin_upload.supplier_details_file.attach(io: File.open(supplier_details_file_path), filename: 'test_supplier_details_file.xlsx')
      admin_upload.supplier_services_file.attach(io: File.open(supplier_services_file_path), filename: 'test_supplier_services_file.xlsx')
      admin_upload.supplier_regions_file.attach(io: File.open(supplier_regions_file_path), filename: 'test_supplier_regions_file.xlsx')
    end
  end

  let(:supplier_details_file) { FacilitiesManagement::RM6232::SupplierDetailsFile.new(**supplier_details_file_options) }
  let(:supplier_details_file_path) { FacilitiesManagement::RM6232::SupplierDetailsFile::OUTPUT_PATH }
  let(:supplier_details_file_options) { {} }

  let(:supplier_services_file) { FacilitiesManagement::RM6232::SupplierServicesFile.new(**supplier_services_file_options) }
  let(:supplier_services_file_path) { FacilitiesManagement::RM6232::SupplierServicesFile::OUTPUT_PATH }
  let(:supplier_services_file_options) { {} }

  let(:supplier_regions_file) { FacilitiesManagement::RM6232::SupplierRegionsFile.new(**supplier_regions_file_options) }
  let(:supplier_regions_file_path) { FacilitiesManagement::RM6232::SupplierRegionsFile::OUTPUT_PATH }
  let(:supplier_regions_file_options) { {} }

  let(:files_importer) { described_class.new(upload) }

  before do
    FacilitiesManagement::RM6232::Admin::Upload::ATTRIBUTES.each do |file|
      send(file).build
      send(file).write
    end
  end

  describe 'check_files' do
    before { files_importer.import_data }

    context 'when the files have the wrong sheets' do
      let(:supplier_details_file_options) { { sheets: ['All suppliers'] } }
      let(:supplier_services_file_options) { { sheets: ['Lot 1a', 'Lot 1b', 'Lot 1c', 'Lot 2b', 'Lot 2c', 'Lot 3a', 'Lot 3b', 'Lot 3c'] } }
      let(:supplier_regions_file_options) { { sheets: ['Lot 1a', 'Lot 1b', 'Lot 2a', 'Lot 1c', 'Lot 2b', 'Lot 2c', 'Lot 3a', 'Lot 3b', 'Lot 3c'] } }

      it 'changes the state to failed and has the correct errors' do
        expect(upload).to have_state(:failed)
        expect(upload.import_errors).to eq [{ error: 'supplier_details_missing_sheets' },
                                            { error: 'supplier_services_missing_sheets' },
                                            { error: 'supplier_regions_missing_sheets' }]
      end
    end

    context 'when the files have the wrong headers and columns' do
      let(:supplier_details_file_options) { { headers: FacilitiesManagement::RM6232::SupplierDetailsFile.sheets_with_extra_headers(['RM6232 Suppliers Details']) } }
      let(:supplier_services_file_options) { { headers: FacilitiesManagement::RM6232::SupplierServicesFile.sheets_with_extra_headers(['Lot 1a', 'Lot 2b', 'Lot 3c']) } }
      let(:supplier_regions_file_options) { { headers: FacilitiesManagement::RM6232::SupplierRegionsFile.sheets_with_extra_headers(['Lot 2a', 'Lot 2b']) } }

      it 'changes the state to failed and has the correct errors' do
        expect(upload).to have_state(:failed)
        expect(upload.import_errors).to eq(
          [
            { error: 'supplier_details_has_incorrect_headers' },
            { error: 'supplier_services_has_incorrect_headers', details: ['Lot 1a', 'Lot 2b', 'Lot 3c'] },
            { error: 'supplier_regions_has_incorrect_headers', details: ['Lot 2a', 'Lot 2b'] }
          ]
        )
      end
    end

    context 'when the files are empty' do
      let(:supplier_details_file_options) { { empty: true } }
      let(:supplier_services_file_options) { { empty: true } }
      let(:supplier_regions_file_options) { { empty: true } }

      it 'changes the state to failed and has the correct errors' do
        expect(upload).to have_state(:failed)
        expect(upload.import_errors).to eq(
          [
            { error: 'supplier_details_has_empty_sheets' },
            { error: 'supplier_services_has_empty_sheets', details: ['Lot 1a', 'Lot 1b', 'Lot 1c', 'Lot 2a', 'Lot 2b', 'Lot 2c', 'Lot 3a', 'Lot 3b', 'Lot 3c'] },
            { error: 'supplier_regions_has_empty_sheets', details: ['Lot 1a', 'Lot 1b', 'Lot 1c', 'Lot 2a', 'Lot 2b', 'Lot 2c', 'Lot 3a', 'Lot 3b', 'Lot 3c'] }
          ]
        )
      end
    end
  end

  describe 'check_processed_data' do
    before { files_importer.import_data }

    context 'when a supplier has no details' do
      let(:supplier_services_file_options) { { extra_supplier: ['Malos LTD', '987654321'] } }
      let(:supplier_regions_file_options) { { extra_supplier: ['Amalthus Ministry', '987654321'] } }

      it 'changes the state to failed and has the correct errors' do
        expect(upload).to have_state(:failed)
        expect(upload.import_errors).to eq [{ error: 'supplier_missing_details', details: ['Malos LTD'] }]
      end
    end

    context 'when a supplier has no lot data' do
      let(:supplier_details_file_options) { { extra_supplier: ['Malos LTD', 'Yes', '987654321', '0123456', '1 Pyra road', nil, 'Argentum', nil, 'AA3 1XC'] } }

      it 'changes the state to failed and has the correct errors' do
        expect(upload).to have_state(:failed)
        expect(upload.import_errors).to eq [{ error: 'supplier_missing_lot_data', details: ['Malos LTD'] }]
      end
    end

    context 'when a supplier has no services' do
      let(:supplier_details_file_options) { { extra_supplier: ['Wild Ride Corp', 'Yes', '987654321', '0123456', '1 Pyra road', nil, 'Argentum', nil, 'AA3 1XC'] } }
      let(:supplier_regions_file_options) { { extra_supplier: ['Wild Ride Corp', '987654321'] } }

      it 'changes the state to failed and has the correct errors' do
        expect(upload).to have_state(:failed)
        expect(upload.import_errors).to eq [{ error: 'supplier_missing_services', details: ['Wild Ride Corp'] }]
      end
    end

    context 'when a suppliers has no regions' do
      let(:supplier_details_file_options) { { extra_supplier: ['Silver Ethel Society', 'Yes', '987654321', '0123456', '1 Pyra road', nil, 'Argentum', nil, 'AA3 1XC'] } }
      let(:supplier_services_file_options) { { extra_supplier: ['Silver Ethel Society', '987654321'] } }

      it 'changes the state to failed and has the correct errors' do
        expect(upload).to have_state(:failed)
        expect(upload.import_errors).to eq [{ error: 'supplier_missing_regions', details: ['Silver Ethel Society'] }]
      end
    end
  end

  describe 'import_data' do
    context 'when considering the imported data' do
      before { files_importer.import_data }

      let(:expected_supplier_results) do
        {
          'Rex LTD': { lot_codes: %w[1a 2a 3a] },
          'Nia Corp': { lot_codes: %w[1a 2a 3a] },
          'Tora LTD': { lot_codes: %w[1a 1b 2a 2b 3a 3b] },
          'Vandham Eexc Corp': { lot_codes: %w[1b 2b 3b] },
          'Morag Jewel LTD': { lot_codes: %w[1b 1c 2b 2c 3b 3c] },
          'ZEKE VON GEMBU Corp': { lot_codes: %w[1c 2c 3c] },
          'Jin Corp': { lot_codes: %w[1c 2c 3c] }
        }
      end

      it 'publishes the data and all the suppliers are imported' do
        expect(upload).to have_state(:published)
        expect(FacilitiesManagement::RM6232::Supplier.count).to eq 7
      end

      it 'has the correct data for the suppliers' do
        expected_supplier_results.each do |supplier_name, expected_results|
          supplier = FacilitiesManagement::RM6232::Supplier.find_by(supplier_name:)

          expect(supplier.lot_data.pluck(:lot_code)).to match_array(expected_results[:lot_codes])
        end
      end
    end

    context 'when the status column is present' do
      before { files_importer.import_data }

      let(:supplier_details_file_options) { { headers: [FacilitiesManagement::RM6232::SupplierDetailsFile::HEADERS + ['Status']] } }
      let(:expected_supplier_results) do
        {
          'Rex LTD': true,
          'Nia Corp': true,
          'Tora LTD': false,
          'Vandham Eexc Corp': true,
          'Morag Jewel LTD': true,
          'ZEKE VON GEMBU Corp': false,
          'Jin Corp': true
        }
      end

      it 'imports the supplier data with the correct status' do
        expected_supplier_results.each do |supplier_name, expected_result|
          supplier = FacilitiesManagement::RM6232::Supplier.find_by(supplier_name:)

          expect(supplier.active).to be expected_result
        end
      end
    end

    context 'when considering the supplier data' do
      it 'has created a supplier data object' do
        expect { files_importer.import_data }.to change(FacilitiesManagement::RM6232::Admin::SupplierData, :count).by(1)
      end
    end
  end
end
