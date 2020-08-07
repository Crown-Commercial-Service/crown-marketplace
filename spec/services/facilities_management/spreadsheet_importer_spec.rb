require 'rails_helper'

RSpec.describe FacilitiesManagement::SpreadsheetImporter do
  subject(:importer) { described_class.new(spreadsheet_import) }

  let(:spreadsheet_import) do
    FacilitiesManagement::SpreadsheetImport.new.tap do |import|
      import.procurement = build(:facilities_management_procurement_detailed_search)
      import.spreadsheet_file.attach(io: File.open(uploaded_file), filename: 'test.xlsx')
    end
  end

  describe '#basic_data_validation' do
    subject(:errors) { importer.basic_data_validation }

    context 'when uploaded file is true to template' do
      let(:uploaded_file) { described_class::TEMPLATE_FILE_PATH }

      it 'no errors' do
        expect(errors).to be_empty
      end
    end

    context 'when uploaded file differs from template' do
      let(:uploaded_file) do
        Rails.root.join('data', 'facilities_management', 'RM3830 Suppliers Details (for Dev & Test).xlsx')
      end

      it 'includes template invalid error' do
        expect(errors).to include(:template_invalid)
      end

      it 'includes not ready error' do
        expect(errors).to include(:not_ready)
      end
    end
  end

  describe '#import_buildings' do
    pending
  end

  describe '#import_services' do
    pending
  end
end
