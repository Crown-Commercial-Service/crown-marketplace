require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::SupplierShortlistSpreadsheetCreator do
  let(:procurement) { create(:facilities_management_rm3830_procurement, user: user, service_codes: ['G.9', 'H.1', 'L.11'], region_codes: ['UKF3', 'UKM28', 'UKM36', 'UKM62', 'UKN03'], contract_name: 'My quick view test', aasm_state: 'quick_search') }
  let(:user) { create(:user, :with_detail) }
  let(:buyer_detail) { user.buyer_detail }
  let(:spreadsheet_builder) { described_class.new(procurement.id) }
  let(:work_book) do
    spreadsheet_builder.build
    File.write('/tmp/quick_view_results.xlsx', spreadsheet_builder.to_xlsx, binmode: true)
    Roo::Excelx.new('/tmp/quick_view_results.xlsx')
  end

  context 'when considering the regions sheet' do
    let(:sheet) { work_book.sheet('Regions') }

    it 'has the correct regions' do
      expect(sheet.row(1)).to eq ['NUTS Code', 'Region Name']

      expect((2..6).map { |row_number| sheet.row(row_number) }).to eq(
        [
          ['UKF3', 'Lincolnshire'],
          ['UKM28', 'West Lothian'],
          ['UKM36', 'North Lanarkshire'],
          ['UKM62', 'Inverness, Nairn, Moray, and Badenoch and Strathspey'],
          ['UKN03', 'East of Northern Ireland (Antrim, Ards, Ballymena, Banbridge, Craigavon, Down, Larne)']
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
          ['G.9', 'Reactive cleaning (outside cleaning operational hours)'],
          ['H.1', 'Mail services'],
          ['L.11', 'Training establishment management and booking service']
        ]
      )
    end
  end

  context 'when considering the Supplier shortlists sheet' do
    let(:sheet) { work_book.sheet('Supplier shortlists') }

    it 'has the correct suppliers' do
      expect(sheet.column(1)[7..]).to eq ['Bogan-Koch', 'Dare, Heaney and Kozey', 'Dickinson-Abbott', "Halvorson, Corwin and O'Connell", 'Hirthe-Mills', 'Lebsack, Vandervort and Veum', 'Leffler-Strosin', 'Marvin, Kunde and Cartwright', "O'Keefe LLC", "O'Keefe-Mitchell", 'Shields, Ratke and Parisian', nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
      expect(sheet.column(2)[7..]).to eq ['Abbott-Dooley', 'Bogan-Koch', 'Dickens and Sons', 'Dickinson-Abbott', 'Ebert Inc', 'Feest-Blanda', 'Gleichner, Thiel and Weissnat', 'Graham-Farrell', "Halvorson, Corwin and O'Connell", 'Kemmer Inc', 'Lebsack, Vandervort and Veum', 'Leffler-Strosin', 'Mann Group', 'Marvin, Kunde and Cartwright', 'Mayert, Kohler and Schowalter', 'Nader, Prosacco and Gaylord', "O'Keefe LLC", "O'Keefe-Mitchell", 'Orn-Welch', 'Sanford LLC', 'Sanford-Lubowitz', 'Smitham-Brown', 'Treutel Inc', 'Wiza, Kunde and Gibson']
      expect(sheet.column(3)[7..]).to eq ['Abbott-Dooley', 'Dickens and Sons', 'Ebert Inc', 'Feest-Blanda', 'Gleichner, Thiel and Weissnat', 'Graham-Farrell', 'Huels, Borer and Rowe', 'Kemmer Inc', 'Koch-Kirlin', 'Mann Group', 'Mayert, Kohler and Schowalter', 'Nader, Prosacco and Gaylord', 'Orn-Welch', 'Sanford LLC', 'Sanford-Lubowitz', 'Smitham-Brown', 'Terry-Konopelski', 'Treutel Inc', 'Wiza, Kunde and Gibson', nil, nil, nil, nil, nil]
    end
  end

  context 'when considering the Customer Details sheet' do
    let(:sheet) { work_book.sheet('Customer Details') }

    it 'has the correct buyer details' do
      buyer_details = ['My quick view test', nil, nil, buyer_detail.organisation_name, buyer_detail.full_organisation_address, buyer_detail.full_name, buyer_detail.job_title, buyer_detail.email, buyer_detail.telephone_number.to_i]

      expect(sheet.column(2)[1..]).to eq buyer_details
    end
  end
end
