require 'roo'
require 'json'
require 'capybara'

def add_suppliers
  filename = '/Users/mike/feature/LS-143/storage/legal_services/current_data/input/Suppliers.csv'
  filename_out = '/Users/mike/feature/LS-143/storage/legal_services/current_data/output/Suppliers.json'
  suppliers_workbook = Roo::CSV.new(filename, csv_options: { encoding: Encoding::ISO_8859_1 })

  headers = {
    name: 'Firm Name',
    contact_email: 'Generic Contact:  Email address',
    telephone_number: 'Generic Contact Phone number',
    website: 'Generic Contact: Website URL',
    address: 'Generic Contact: Postal address',
    sme: 'Is an SME?',
    duns: 'DUNS Number',
    lot1: 'Lot 1: Prospectus Link',
    lot2: 'Lot 2: Prospectus Link',
    lot3: 'Lot 3: Prospectus Link',
    lot4: 'Lot 4: Prospectus Link',
    about: 'About the supplier'
  }

  # options = { col_sep: ',', encoding: Encoding::ISO_8859_1, liberal_parsing: true }

  # CSV.foreach(filename, options) { |row| puts row }

  ls_sheet = suppliers_workbook.sheet(0)

  suppliers = ls_sheet.parse(headers)

  File.open(filename_out, 'w') do |f|
    f.write JSON.pretty_generate suppliers
  end
end

add_suppliers
