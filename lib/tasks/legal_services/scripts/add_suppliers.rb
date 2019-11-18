require 'roo'
require 'json'

def add_suppliers
  suppliers_workbook = Roo::Spreadsheet.open(suppliers_file_path, extension: :xlsx)

  headers = {
    name: 'Supplier Name',
    email: 'Email address',
    phone_number: 'Phone number',
    website: 'Website URL',
    address: 'Postal address',
    sme: 'Is an SME',
    duns: 'DUNS Number',
    lot_1_prospectus_link: 'Lot 1: Prospectus Link',
    lot_2_prospectus_link: 'Lot 2: Prospectus Link',
    lot_3_prospectus_link: 'Lot 3: Prospectus Link',
    lot_4_prospectus_link: 'Lot 4: Prospectus Link',
    clean: true
  }

  sheet = suppliers_workbook.sheet(0)

  suppliers = sheet.parse(headers)

  suppliers.each do |supplier|
    supplier[:sme] = ['YES', 'Y'].include? supplier[:sme].to_s.upcase
    supplier[:id] = SecureRandom.uuid
  end

  write_ls_output_file('suppliers.json', suppliers)
end

def suppliers_file_path
  'storage/legal_services/current_data/input/Suppliers.xlsx'
end
