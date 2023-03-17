require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::SupplierShortlistSpreadsheetCreator do
  let(:procurement) { create(:facilities_management_rm6232_procurement, user: user, service_codes: %w[E.5 M.1 P.8], region_codes: %w[UKC1 UKD1 UKF3 UKH3], annual_contract_value: 500_000, contract_name: 'My search test') }
  let(:user) { create(:user, :with_detail) }
  let(:buyer_detail) { user.buyer_detail }
  let(:spreadsheet_builder) { described_class.new(procurement.id) }
  let(:work_book) do
    spreadsheet_builder.build
    File.write('/tmp/selected_suppliers.xlsx', spreadsheet_builder.to_xlsx, binmode: true)
    Roo::Excelx.new('/tmp/selected_suppliers.xlsx')
  end

  context 'when considering the regions sheet' do
    let(:sheet) { work_book.sheet('Regions') }

    it 'has the correct regions' do
      expect(sheet.row(1)).to eq ['NUTS Code', 'Region Name']

      expect((2..5).map { |row_number| sheet.row(row_number) }).to eq(
        [
          ['UKC1', 'Tees Valley and Durham'],
          ['UKD1', 'Cumbria'],
          ['UKF3', 'Lincolnshire'],
          ['UKH3', 'Essex']
        ]
      )
    end
  end

  context 'when considering the services sheet' do
    let(:sheet) { work_book.sheet('Services') }

    it 'has the correct services' do
      expect(sheet.row(1)).to eq ['Service Reference', 'Service Name']

      expect((2..4).map { |row_number| sheet.row(row_number) }).to eq(
        [
          ['E.5', 'Lifts, hoists and conveyance systems maintenance'],
          ['M.1', 'On Site / Mobile Classified Waste Shredding Service'],
          ['P.8', 'Accommodation Stores Service']
        ]
      )
    end
  end

  context 'when considering the Supplier shortlists sheet' do
    let(:sheet) { work_book.sheet('Supplier shortlists') }

    it 'has the correct reference number' do
      expect(sheet.row(2)).to eq ['Reference number:', procurement.contract_number]
    end

    it 'has the correct estimated annual cost' do
      expect(sheet.row(3)).to eq ['Estimated annual cost:', 500000]
    end

    it 'has the correct lot' do
      expect(sheet.row(7)).to eq ['Sub-lot 2a', nil]
    end

    it 'has the correct suppliers' do
      expect(sheet.column(1)[7..]).to eq ['Dach Inc', 'Feest Group', 'Harber LLC', 'Hudson, Spinka and Schuppe', 'Metz Inc', "O'Reilly, Emmerich and Reichert", 'Roob-Kessler', 'Skiles LLC', 'Torphy Inc', 'Turner-Pouros']
    end
  end

  context 'when considering the Customer Details sheet' do
    let(:sheet) { work_book.sheet('Customer Details') }

    it 'has the correct buyer details' do
      buyer_details = ['My search test', nil, nil, buyer_detail.organisation_name, buyer_detail.full_organisation_address, buyer_detail.full_name, buyer_detail.job_title, buyer_detail.email, buyer_detail.telephone_number.to_i]

      expect(sheet.column(2)[1..]).to eq buyer_details
    end
  end
end
