require 'roo'
require 'json'

def add_suppliers(upload_id)
  upload = LegalServices::Admin::Upload.find(upload_id)
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

  sheet = suppliers_workbook.sheet(0)

  suppliers = sheet.parse(headers)
  upload.data = JSON.pretty_generate suppliers
end
