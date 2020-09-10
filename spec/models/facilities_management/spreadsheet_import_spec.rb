require 'rails_helper'

RSpec.describe FacilitiesManagement::SpreadsheetImport, type: :model do
  subject(:import) { create(:facilities_management_procurement_spreadsheet_import, procurement: create(:facilities_management_procurement, aasm_state: 'detailed_search_bulk_upload', user: create(:user))) }

  describe 'aasm_state' do
    it 'starts at upload state' do
      expect(import.aasm_state).to eq('upload')
    end

    context 'when start_import is called' do
      before do
        allow(FacilitiesManagement::UploadSpreadsheetWorker).to receive(:perform_async).with(import.id).and_return(true)
        import.start_import!
      end

      it 'starts the worker' do
        expect(FacilitiesManagement::UploadSpreadsheetWorker).to have_received(:perform_async).with(import.id)
      end

      it 'set the state to importing' do
        expect(import.importing?).to be true
      end
    end
  end

  # describe 'spreadsheet_file' do
  #  context 'when not attached' do
  #    before { import.valid?(:upload) }

  #    it 'must be uploaded error' do
  #      # expect(import.errors.full_messages.grep(/Select your/).size).to eq(1)
  #    end
  #  end

  # context 'when wrong type of file' do
  #  before do
  #    import.spreadsheet_file.attach(io: File.open(Rails.root.join('Gemfile')), filename: 'Gemfile')
  #    import.valid?(:upload)
  #  end

  # it 'wrong extension error message' do
  #   expect(import.errors.full_messages.grep(/must be a XLSX/).size).to eq(1)
  # end

  # it 'wrong content type message' do
  #   expect(import.errors.full_messages.grep(/expected content type/).size).to eq(1)
  # end
  # end
  # end
end
