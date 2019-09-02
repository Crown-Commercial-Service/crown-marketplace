require 'roo'
require 'json'

def add_suppliers(upload_id)
  upload = LegalServices::Admin::Upload.find(upload_id)
  suppliers_workbook = Roo::Spreadsheet.open(file_path(upload.suppliers))

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

  upload.data = suppliers
  upload.save!
end

def file_path(file)
  return file.path if Rails.env.development?

  "https://s3-#{ENV['COGNITO_AWS_REGION']}.amazonaws.com/#{ENV['CCS_APP_API_DATA_BUCKET']}/#{file.url}"
end
