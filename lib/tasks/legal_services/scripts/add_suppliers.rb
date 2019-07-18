require 'roo'
require 'json'
require 'capybara'
require 'byebug'

def add_suppliers
  suppliers_workbook = Roo::Spreadsheet.open '/users/milomia/master/storage/legal_services/current_data/input/SupplierDetails4.xlsx'

  headers = {
    name: 'Supplier Name',
    contact_email: 'Email address',
    telephone_number: 'Phone number',
    website: 'Website URL',
    address: 'Postal address',
    sme: 'Is an SME',
    duns: 'DUNS Number',
    lot1: 'Lot 1 Prospectus Link',
    lot2: 'Lot 2 Prospectus Link',
    lot3: 'Lot 3 Prospectus Link',
    lot4: 'Lot 4 Prospectus Link',
    clean: true
  }

  ls_sheet = suppliers_workbook.sheet(0)

  suppliers = ls_sheet.parse(headers)

  File.open('/users/milomia/master/storage/legal_services/current_data/output/suppliers2.json', 'w') do |f|
    f.write JSON.pretty_generate suppliers
  end
end

add_suppliers
