require 'csv'
require 'roo'
require 'json'

accredited_suppliers_workbook = Roo::Spreadsheet.open './lib/tasks/supply_teachers/input/Current_Accredited_Suppliers_.xlsx'

suppliers = []
csv = CSV.open('./lib/tasks/supply_teachers/input/supplier_lookup.csv', headers: true)
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