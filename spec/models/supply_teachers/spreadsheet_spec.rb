require 'rails_helper'

RSpec.describe SupplyTeachers::Spreadsheet do
  let(:telephone_number) { '0121 496 0123' }
  let(:branch1) { build(:supply_teachers_branch_search_result, telephone_number: telephone_number) }
  let(:branch2) { build(:supply_teachers_branch_search_result, telephone_number: '029 2018 0999') }

  context 'without calculations' do
    subject(:spreadsheet) { described_class.new([branch1, branch2]) }

    describe 'the generated worksheet' do
      let(:worksheet) { workbook.worksheets.first }
      let(:workbook) { RubyXL::Parser.parse_buffer(StringIO.new(spreadsheet.to_xlsx)) }

      it 'is has the name Suppliers' do
        expect(worksheet.sheet_name).to eq 'Agency shortlist'
      end

      it 'has two header row and two data rows' do
        expect(worksheet.to_a.size).to eq 4
      end

      it 'has the correct header row 1' do
        expect(worksheet[0].cells.map(&:value)).to eq [
          'Agency list'
        ]
      end

      it 'has the correct header row 2' do
        expect(worksheet[1].cells.map(&:value)).to eq [
          'Agency name',
          'Branch name',
          'Contact name',
          'Contact email',
          'Telephone number'
        ]
      end

      it 'has the correct data for branch 1' do
        expect(worksheet[2].cells.map(&:value)).to eq [
          branch1.supplier_name,
          branch1.name,
          branch1.contact_name,
          branch1.contact_email,
          branch1.telephone_number
        ]
      end

      it 'has the correct data for branch 2' do
        expect(worksheet[3].cells.map(&:value)).to eq [
          branch2.supplier_name,
          branch2.name,
          branch2.contact_name,
          branch2.contact_email,
          branch2.telephone_number
        ]
      end

      context 'when the phone number is valid' do
        let(:telephone_number) { '01214960123' }

        it 'is formatted' do
          expect(worksheet[2].cells.map(&:value)[4])
            .to eq('0121 496 0123')
        end
      end

      context 'when the phone number is invalid' do
        let(:telephone_number) { '0111111111111' }

        it 'does not become a number' do
          expect(worksheet[2].cells.map(&:value)[4])
            .to eq(telephone_number)
        end
      end
    end
  end

  context 'with calculations' do
    subject(:spreadsheet) { described_class.new([branch1, branch2], with_calculations: true) }

    let(:worksheet) { workbook.worksheets.first }
    let(:workbook) { RubyXL::Parser.parse_buffer(StringIO.new(spreadsheet.to_xlsx)) }

    describe '#sheet_name' do
      it 'returns the sheet name' do
        expect(worksheet.sheet_name).to eq('Agency shortlist')
      end
    end

    describe '#title' do
      it 'has the correct header row 2' do
        expect(worksheet[1].cells.map(&:value)).to eq [
          'Agency name', 'Branch name', 'Contact name',
          'Contact email', 'Telephone number', 'Mark-up',
          'Enter daily rate', 'Cost of the worker', 'Agency fee'
        ]
      end
    end
  end
end
