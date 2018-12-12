require 'rails_helper'

RSpec.describe SupplyTeachers::AuditSpreadsheet do
  include TelephoneNumberHelper

  subject(:spreadsheet) { described_class.new }

  let!(:branch) { create(:supply_teachers_branch) }
  let!(:rate) { create(:supply_teachers_rate) }

  describe 'the branch worksheet' do
    let(:worksheet) { workbook.worksheets.first }
    let(:workbook) { RubyXL::Parser.parse_buffer(StringIO.new(spreadsheet.to_xlsx)) }

    it 'has the name branches' do
      expect(worksheet.sheet_name).to eq 'branches'
    end

    it 'has one header row and one data row' do
      expect(worksheet.to_a.size).to eq 2
    end

    it 'has the correct header row' do
      expect(worksheet[0].cells.map(&:value)).to eq [
        'supplier.name',
        'postcode',
        'contact_name',
        'contact_email',
        'telephone_number',
        'name',
        'town'
      ]
    end

    it 'has the correct data' do
      expect(worksheet[1].cells.map(&:value)).to eq [
        branch.supplier.name,
        branch.postcode,
        branch.contact_name,
        branch.contact_email,
        format_telephone_number(branch.telephone_number),
        branch.name,
        branch.town,
      ]
    end
  end

  describe 'the rate worksheet' do
    let(:worksheet) { workbook.worksheets[1] }
    let(:workbook) { RubyXL::Parser.parse_buffer(StringIO.new(spreadsheet.to_xlsx)) }

    it 'has the name rates' do
      expect(worksheet.sheet_name).to eq 'rates'
    end

    it 'has one header row and one data row' do
      expect(worksheet.to_a.size).to eq 2
    end

    it 'has the correct header row' do
      expect(worksheet[0].cells.map(&:value)).to eq [
        'supplier.name',
        'job_type',
        'mark_up',
        'term',
        'lot_number',
        'daily_fee'
      ]
    end

    it 'has the correct data' do
      expect(worksheet[1].cells.map(&:value)).to eq [
        rate.supplier.name,
        rate.job_type,
        rate.mark_up,
        rate.term,
        rate.lot_number,
        rate.daily_fee
      ]
    end
  end
end
