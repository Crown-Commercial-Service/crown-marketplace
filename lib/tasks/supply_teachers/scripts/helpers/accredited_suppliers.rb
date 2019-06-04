require 'csv'
require 'roo'
require 'json'
require 'aws-sdk-s3'


object = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])
accredited_suppliers_path = './storage/supply_teachers/current_data/input/current_accredited_suppliers.xlsx'
FileUtils.touch(accredited_suppliers_path)
object.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object(SupplyTeachers::Admin::Upload::CURRENT_ACCREDITED_PATH).get(response_target: accredited_suppliers_path)
supplier_lookup_path = './storage/supply_teachers/current_data/input/supplier_lookup.csv'
FileUtils.touch(supplier_lookup_path)
object.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object(SupplyTeachers::Admin::Upload::SUPPLIER_LOOKUP_PATH).get(response_target: supplier_lookup_path )

accredited_suppliers_workbook = Roo::Spreadsheet.open accredited_suppliers_path
suppliers = []
csv = CSV.open(supplier_lookup_path, headers: true)
csv.each do |row|
  suppliers << row.to_h.transform_keys!(&:to_sym)
end

lot_1_accreditation_sheet = accredited_suppliers_workbook.sheet('Lot 1 - Preferred Supplier List')
lot_1_accreditation =
  lot_1_accreditation_sheet.parse(header_search: ['Supplier Name - Accreditation Held'])

lot_2_accreditation_sheet = accredited_suppliers_workbook.sheet('Lot 2 - Master Vendor MSP')
lot_2_accreditation =
  lot_2_accreditation_sheet.parse(header_search: ['Supplier Name - Accreditation Held'])

lot_3_accreditation_sheet = accredited_suppliers_workbook.sheet('Lot 3 - Neutral Vendor MSP')
lot_3_accreditation =
  lot_3_accreditation_sheet.parse(header_search: ['Supplier Name'])

accredited_suppliers_hashes = lot_1_accreditation + lot_2_accreditation + lot_3_accreditation
accredited_supplier_names = accredited_suppliers_hashes.map(&:values).flatten

@accredited_suppliers = suppliers.select do |supplier|
  accredited_supplier_names.include?(supplier[:'accreditation supplier name'])
end
# rubocop:disable Style/PreferredHashMethods, Rails/Blank
def supplier_accredited?(id)
  return false if id.nil? || id.empty?

  @accredited_suppliers.select { |supplier| supplier.has_value?(id) }.any?
end
# rubocop:enable Style/PreferredHashMethods, Rails/Blank
