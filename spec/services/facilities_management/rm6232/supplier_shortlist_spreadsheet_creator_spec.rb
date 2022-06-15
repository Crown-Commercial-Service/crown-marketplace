require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::SupplierShortlistSpreadsheetCreator do
  let(:procurement) { create(:facilities_management_rm6232_procurement_no_procurement_buildings, :skip_before_create, user: user, service_codes: %w[E.5 M.1 P.8], region_codes: %w[UKC1 UKD1 UKF3 UKH3], annual_contract_value: 500_000, contract_name: 'My search test', aasm_state: 'what_happens_next') }
  let(:user) { create(:user, :with_detail) }
  let(:buyer_detail) { user.buyer_detail }
  let(:spreadsheet_builder) { described_class.new(procurement.id) }
  let(:work_book) do
    spreadsheet_builder.build
    IO.write('/tmp/selected_suppliers.xlsx', spreadsheet_builder.to_xlsx, binmode: true)
    Roo::Excelx.new('/tmp/selected_suppliers.xlsx')
  end

  context 'when considering the regions sheet' do
    let(:sheet) { work_book.sheet('Regions') }

    it 'has the correct regions' do
      expect(sheet.column(1)).to eq ['Regions', 'Tees Valley and Durham', 'Cumbria', 'Lincolnshire', 'Essex']
    end
  end

  context 'when considering the services sheet' do
    let(:sheet) { work_book.sheet('Services') }

    # rubocop:disable RSpec/MultipleExpectations
    it 'has the correct services' do
      expect(sheet.row(1)).to eq ['Service Reference', 'Service Name']
      expect(sheet.row(2)).to eq ['E.5', 'Lifts, hoists and conveyance systems maintenance']
      expect(sheet.row(3)).to eq ['M.1', 'On Site / Mobile Classified Waste Shredding Service']
      expect(sheet.row(4)).to eq ['P.8', 'Accommodation Stores Service']
    end
    # rubocop:enable RSpec/MultipleExpectations
  end

  context 'when considering the Supplier shortlists sheet' do
    let(:sheet) { work_book.sheet('Supplier shortlists') }

    it 'has the correct suppliers' do
      expect(sheet.column(1)[6..]).to eq ['Dach Inc', 'Feest Group', 'Harber LLC', 'Hudson, Spinka and Schuppe', 'Metz Inc', "O'Reilly, Emmerich and Reichert", 'Roob-Kessler', 'Skiles LLC', 'Torphy Inc', 'Turner-Pouros']
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
