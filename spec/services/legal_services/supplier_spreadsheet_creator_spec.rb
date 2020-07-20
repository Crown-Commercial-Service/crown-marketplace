require 'rails_helper'

RSpec.describe LegalServices::SupplierSpreadsheetCreator do
  let(:supplier) { create(:management_consultancy_supplier) }
  let(:suppliers) { LegalServices::Supplier.where(id: supplier.id) }
  let(:lot_number) { '1' }
  let(:lot) { LegalServices::Lot.find_by(number: lot_number) }
  let(:services) { LegalServices::Service.all.sample(5).map(&:code) }
  let(:region_codes) { Nuts1Region.all.sample(5).map(&:code) }
  let(:params) { { 'region_codes' => region_codes, 'services' => services, 'lot' => lot_number } }
  let(:spreadsheet_creator) { described_class.new(suppliers, params) }

  before do
    allow(LegalServices::Supplier).to receive(:offering_services_in_regions)
      .with(lot_number, services, nil, region_codes).and_return(suppliers)
  end

  describe '.build' do
    it 'returns an Axlsx::Package' do
      spreadsheet = spreadsheet_creator.build
      expect(spreadsheet.class).to eq(Axlsx::Package)
    end

    it 'returns checks worksheet headers' do
      spreadsheet = spreadsheet_creator.build
      IO.write('/tmp/shortlist_of_management_consultancy_suppliers.xlsx', spreadsheet.to_stream.read)
      wb = Roo::Excelx.new('/tmp/shortlist_of_management_consultancy_suppliers.xlsx')
      expect(wb.sheet('Supplier shortlist').row(1)).to eq ['Supplier name', 'Phone number', 'Email']
      expect(wb.sheet('Shortlist audit').row(1)).to eq ['Central Government user?', nil]
      expect(wb.sheet('Shortlist audit').row(2)).to eq ['Lot', '1 - Regional service provision']
    end
  end
end
