require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Admin::SupplierFrameworkDataSpreadsheet do
  subject(:workbook) { Roo::Spreadsheet.open(spreadsheet_file) }

  let(:spreadsheet_file) { Tempfile.new(['supplier_framework_data_spreadsheet', '.xlsx']) }

  before do
    spreadsheet_builder = described_class.new
    spreadsheet_builder.build
    File.write(spreadsheet_file, spreadsheet_builder.to_xlsx, binmode: true)
  end

  after do
    spreadsheet_file.unlink
  end

  context 'when considering the Prices sheet' do
    let(:sheet) { workbook.sheet('Prices') }

    it 'has the correct headings' do
      expect(sheet.row(1)).to eq ['Supplier', 'Service Ref', 'Service Name', 'Unit of Measure', 'General office - Customer Facing', 'General office - Non Customer Facing', 'Call Centre Operations', 'Warehouses', 'Restaurant and Catering Facilities', 'Pre-School', 'Primary School', 'Secondary Schools', 'Special Schools', 'Universities and Colleges', 'Community - Doctors, Dentist, Health Clinic', 'Nursing and Care Homes', 'Direct Award Discount %']
    end

    it 'has the expected ammount of data' do
      expect(sheet.last_row).to eq 1171
    end

    it 'has the right data in a sample of rows' do
      expect(sheet.row(235)).to eq ['Dare, Heaney and Kozey', 'C.13', 'High voltage (HV) and switchgear maintenance - Standard A', 'Square Metre (GIA) per annum', nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
      expect(sheet.row(511)).to eq ['Kulas, Schultz and Moore', 'E.6', 'Conditions survey', 'Square Metre (GIA) per annum', nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
      expect(sheet.row(810)).to eq ["O'Keefe LLC", 'N.1', 'Helpdesk services', 'Percentage of Year 1 Deliverables Value (excluding Management and Corporate Overhead, and Profit) at call-off.', nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
    end
  end

  context 'when considering the Variances sheet' do
    let(:sheet) { workbook.sheet('Variances') }

    it 'has the correct headings' do
      expect(sheet.row(1)).to eq ['Supplier', 'Abernathy and Sons', 'Bode and Sons', 'Bogan-Koch', 'Cartwright and Sons', 'Collier Group', 'Dare, Heaney and Kozey', 'Dickinson-Abbott', "Halvorson, Corwin and O'Connell", 'Hickle-Schinner', 'Hirthe-Mills', 'Kemmer Group', 'Kulas, Schultz and Moore', 'Kunze, Langworth and Parisian', 'Lebsack, Vandervort and Veum', 'Leffler-Strosin', 'Marvin, Kunde and Cartwright', 'Mayer-Russel', "O'Keefe LLC", "O'Keefe-Mitchell", 'Rowe, Hessel and Heller', 'Schmeler-Leuschke', 'Shields, Ratke and Parisian', 'Treutel LLC', 'Ullrich, Ratke and Botsford', 'Walsh, Murphy and Gaylord', 'Wolf-Wiza']
    end

    it 'has the correct columns' do
      expect(sheet.column(1)).to eq ['Supplier', 'Management Overhead %', 'Corporate Overhead %', 'Profit %', 'London Location Variance Rate (%)', 'Cleaning Consumables per Building User (£)', 'TUPE Risk Premium (DA %)', 'Mobilisation Cost (DA %)']
    end
  end
end
