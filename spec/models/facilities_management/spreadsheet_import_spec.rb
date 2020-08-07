require 'rails_helper'

RSpec.describe FacilitiesManagement::SpreadsheetImport, type: :model do
  subject(:import) { described_class.new }

  describe 'aasm_state' do
    it 'starts at importing state' do
      expect(import.aasm_state).to eq('importing')
    end
  end

  describe 'spreadsheet_file' do
    context 'when not attached' do
      before { import.valid? }

      it 'must be uploaded error' do
        expect(import.errors.full_messages.grep(/Select your/).size).to eq(1)
      end
    end

    context 'when wrong type of file' do
      before do
        import.spreadsheet_file.attach(io: File.open(Rails.root.join('Gemfile')), filename: 'Gemfile')
        import.valid?
      end

      it 'wrong extension error message' do
        expect(import.errors.full_messages.grep(/must be a XLSX/).size).to eq(1)
      end

      it 'wrong content type message' do
        expect(import.errors.full_messages.grep(/expected content type/).size).to eq(1)
      end
    end
  end
end
