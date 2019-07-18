require 'roo'
require 'json'
require 'capybara'

def add_suppliers
  suppliers_workbook = Roo::Spreadsheet.open '/Users/mike/feature/LS-143/storage/legal_services/current_data/input/Suppliers3.xlsx'

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

  suppliers.delete_if { |supplier| supplier[:duns].nil? }

  suppliers.uniq! { |supplier| supplier[:duns] }

  File.open('/users/mike/feature/LS-143/storage/legal_services/current_data/output/suppliers.json', 'w') do |f|
    f.write JSON.pretty_generate suppliers
  end
end
