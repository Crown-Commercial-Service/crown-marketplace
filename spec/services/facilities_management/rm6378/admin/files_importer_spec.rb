require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6378::Admin::FilesImporter do
  let(:upload) do
    create(:facilities_management_rm6378_admin_upload, aasm_state: 'in_progress') do |admin_upload|
      File.open(supplier_details_file_path, 'rb') do |file_stream|
        admin_upload.supplier_details_file.attach(io: file_stream, filename: 'test_supplier_details_file.xlsx')
      end
      File.open(supplier_services_file_path, 'rb') do |file_stream|
        admin_upload.supplier_services_file.attach(io: file_stream, filename: 'test_supplier_services_file.xlsx')
      end
      File.open(supplier_regions_file_path, 'rb') do |file_stream|
        admin_upload.supplier_regions_file.attach(io: file_stream, filename: 'test_supplier_regions_file.xlsx')
      end
    end
  end

  let(:supplier_details_file) { FacilitiesManagement::RM6378::SupplierDetailsFile.new(**supplier_details_file_options) }
  let(:supplier_details_file_path) { FacilitiesManagement::RM6378::SupplierDetailsFile::OUTPUT_PATH }
  let(:supplier_details_file_options) { {} }

  let(:supplier_services_file) { FacilitiesManagement::RM6378::SupplierServicesFile.new(**supplier_services_file_options) }
  let(:supplier_services_file_path) { FacilitiesManagement::RM6378::SupplierServicesFile::OUTPUT_PATH }
  let(:supplier_services_file_options) { {} }

  let(:supplier_regions_file) { FacilitiesManagement::RM6378::SupplierRegionsFile.new(**supplier_regions_file_options) }
  let(:supplier_regions_file_path) { FacilitiesManagement::RM6378::SupplierRegionsFile::OUTPUT_PATH }
  let(:supplier_regions_file_options) { {} }

  let(:files_importer) { described_class.new(upload) }

  before do
    FacilitiesManagement::RM6378::Admin::Upload::ATTRIBUTES.each do |file|
      send(file).build
      send(file).write
    end

    files_importer.import_data
  end

  describe 'check_files' do
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
      let(:supplier_details_file_options) { { headers: FacilitiesManagement::RM6378::SupplierDetailsFile.sheets_with_extra_headers(['RM6378 Suppliers Details']) } }
      let(:supplier_services_file_options) { { headers: FacilitiesManagement::RM6378::SupplierServicesFile.sheets_with_extra_headers(['Lot 1a', 'Lot 2b', 'Lot 3a']) } }
      let(:supplier_regions_file_options) { { headers: FacilitiesManagement::RM6378::SupplierRegionsFile.sheets_with_extra_headers(['Lot 2a', 'Lot 2b', 'Lot 4d']) } }

      it 'changes the state to failed and has the correct errors' do
        expect(upload).to have_state(:failed)
        expect(upload.import_errors).to eq(
          [
            { error: 'supplier_details_has_incorrect_headers' },
            { error: 'supplier_services_has_incorrect_headers', details: ['Lot 1a', 'Lot 2b', 'Lot 3a'] },
            { error: 'supplier_regions_has_incorrect_headers', details: ['Lot 2a', 'Lot 2b', 'Lot 4d'] }
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
            { error: 'supplier_services_has_empty_sheets', details: ['Lot 1a', 'Lot 1b', 'Lot 1c', 'Lot 2a', 'Lot 2b', 'Lot 3a', 'Lot 3b', 'Lot 4a', 'Lot 4b', 'Lot 4c', 'Lot 4d'] },
            { error: 'supplier_regions_has_empty_sheets', details: ['Lot 1a', 'Lot 1b', 'Lot 1c', 'Lot 2a', 'Lot 2b', 'Lot 3a', 'Lot 3b', 'Lot 4a', 'Lot 4b', 'Lot 4c', 'Lot 4d'] }
          ]
        )
      end
    end
  end

  describe 'check_processed_data' do
    context 'when a supplier has no services' do
      let(:supplier_details_file_options) { { extra_supplier: ['Haze LTD', 'Yes', '987654321'] } }
      let(:supplier_regions_file_options) { { extra_supplier: ['Haze LTD', '987654321'] } }

      it 'changes the state to failed and has the correct errors' do
        expect(upload).to have_state(:failed)
        expect(upload.import_errors).to eq [{ error: 'supplier_missing_services', details: ['Haze LTD'] }]
      end
    end

    context 'when a suppliers has no regions' do
      let(:supplier_details_file_options) { { extra_supplier: ['Minoth Corp', 'Yes', '987654321'] } }
      let(:supplier_services_file_options) { { extra_supplier: ['Minoth Corp', '987654321'] } }

      it 'changes the state to failed and has the correct errors' do
        expect(upload).to have_state(:failed)
        expect(upload.import_errors).to eq [{ error: 'supplier_missing_jurisdictions', details: ['Minoth Corp'] }]
      end
    end
  end

  describe 'import_data' do
    let(:expected_supplier_results) do
      {
        'Rex LTD': { lots: 4, services: 167, jurisdictions: 212 },
        'Nia Corp': { lots: 4, services: 172, jurisdictions: 216 },
        'Tora LTD': { lots: 8, services: 331, jurisdictions: 416 },
        'Vandham Eexc Corp': { lots: 4, services: 165, jurisdictions: 216 },
        'Morag Jewel LTD': { lots: 6, services: 253, jurisdictions: 310 },
        'ZEKE VON GEMBU Corp': { lots: 2, services: 85, jurisdictions: 108 },
        'Jin Corp': { lots: 3, services: 91, jurisdictions: 155 },
        'Addam LTD': { lots: 1, services: 2, jurisdictions: 54 },
        'Hugo Corp': { lots: 1, services: 4, jurisdictions: 51 },
      }
    end
    let(:change_log) { ChangeLog.find_by(user_id: upload.user_id, framework_id: 'RM6378') }

    it 'publishes the data and all the suppliers are imported' do
      expect(upload).to have_state(:published)
      expect(Supplier::Framework.where(framework_id: 'RM6378').count).to eq 9
    end

    it 'creates a change log' do
      expect(change_log.change_type).to eq('upload_supplier_data')
      expect(change_log.change_data['admin_upload_id']).to eq(upload.id)
      expect(change_log.change_data['supplier_data'].length).to eq(9)
    end

    it 'has the correct data for the suppliers' do
      expected_supplier_results.each do |name, expected_results|
        supplier_framework = Supplier.find_by(name:).supplier_frameworks.find_by(framework_id: 'RM6378')

        expect(supplier_framework.lots.count).to eq expected_results[:lots]
        expect(supplier_framework.lots.sum { |lot| lot.services.count }).to eq expected_results[:services]
        expect(supplier_framework.lots.sum { |lot| lot.jurisdictions.count }).to eq expected_results[:jurisdictions]
      end
    end
  end
end
