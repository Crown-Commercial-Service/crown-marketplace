require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6378::SupplierShortlistSpreadsheetCreator do
  let(:procurement) { create(:facilities_management_rm6378_procurement, user: user, contract_name: 'My search test', procurement_details: { 'service_ids' => service_ids, 'jurisdiction_ids' => jurisdiction_ids, 'annual_contract_value' => 500_000 }) }
  let(:service_ids) { %w[RM6378.1a.E5 RM6378.1a.M1 RM6378.1a.P8] }
  let(:jurisdiction_ids) { %w[TLC3 TLD1 TLF3 TLH3] }
  let(:user) { create(:user, :with_detail) }
  let(:buyer_detail) { user.buyer_detail }
  let(:spreadsheet_builder) { described_class.new(procurement.id) }
  let(:work_book) do
    spreadsheet_builder.build
    File.write('/tmp/selected_suppliers.xlsx', spreadsheet_builder.to_xlsx, binmode: true)
    Roo::Excelx.new('/tmp/selected_suppliers.xlsx')
  end

  before do
    [
      create(:supplier_framework_lot, lot_id: 'RM6378.1a', supplier_framework: create(:supplier_framework, framework_id: 'RM6378', supplier: create(:supplier, name: 'Hornet'))),
      create(:supplier_framework_lot, lot_id: 'RM6378.1a', supplier_framework: create(:supplier_framework, framework_id: 'RM6378', supplier: create(:supplier, name: 'Zote the Mighty'))),
      create(:supplier_framework_lot, lot_id: 'RM6378.1a', supplier_framework: create(:supplier_framework, framework_id: 'RM6378', supplier: create(:supplier, name: 'The Knight'))),
    ].each do |supplier_framework_lot|
      service_ids.each do |service_id|
        supplier_framework_lot.services.create(service_id:)
      end
      jurisdiction_ids.each do |jurisdiction_id|
        supplier_framework_lot.jurisdictions.create(jurisdiction_id:)
      end
    end
  end

  context 'when considering the regions sheet' do
    let(:sheet) { work_book.sheet('Regions') }

    it 'has the correct regions' do
      expect(sheet.row(1)).to eq ['ITL Code', 'Region Name']

      expect((2..5).map { |row_number| sheet.row(row_number) }).to eq(
        [
          ['TLC3', 'Tees Valley'],
          ['TLD1', 'Cumbria'],
          ['TLF3', 'Lincolnshire'],
          ['TLH3', 'Essex']
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
          ['E5', 'Lifts maintenance'],
          ['M1', 'On Site / Mobile Classified Waste Shredding Service'],
          ['P8', 'Special Need Or Disability Adaptions']
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
      expect(sheet.row(7)).to eq ['Sub-lot 1a', nil]
    end

    it 'has the correct suppliers' do
      expect(sheet.column(1)[7..]).to eq ['Hornet', 'The Knight', 'Zote the Mighty']
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
