require 'roo'
require 'json'

suppliers = JSON.parse(File.read('./lib/tasks/management_consultancy/output/suppliers_with_service_offering.json'))

regional_offerings_workbook = Roo::Spreadsheet.open './lib/tasks/management_consultancy/input/Regional offerings.xlsx'

sheet_names = {
  'MCF Lot 2 (Finance)' => 'MCF1.2',
  'MCF Lot 3 (Audit)' => 'MCF1.3',
  'MCF Lot 4 (HR)' => 'MCF1.4',
  'MCF Lot 5 (Health & Community)' => 'MCF1.5',
  'MCF Lot 6 (Education)' => 'MCF1.6',
  'MCF Lot 7 (Infrastructure)' => 'MCF1.7',
  'MCF Lot 8 (ICT & Digital Servic' => 'MCF1.8',
  'MCF2 Lot 1 (Business Consultanc' => 'MCF2.1',
  'MCF2 Lot 2 (Procurement, Supply' => 'MCF2.2',
  'MCF2 Lot 3 (Complex & Transform' => 'MCF2.3',
  'MCF2 Lot 4 (Strategic)' => 'MCF2.4'
}

def extract_region_code(region_name)
  region_name.split('(')[1].split(')')[0]
end

(0..10).each do |sheet_number|
  sheet = regional_offerings_workbook.sheet(sheet_number)
  region_names = sheet.row(1)
  lot_number = sheet_names[sheet.default_sheet]

  (2..sheet.last_row).each do |row_number|
    row = sheet.row(row_number)
    supplier_name = row.first
    regional_offerings = []
    row.each_with_index do |value, index|
      next unless value.try(:downcase) == 'x'

      regional_offerings << extract_region_code(region_names[index])
    end

    next unless regional_offerings.size.positive?

    supplier = suppliers.find { |s| s['name'] == supplier_name.strip }
    supplier_lot = supplier['lots'].detect { |lot| lot['lot_number'] == lot_number }
    supplier_lot['regions'] = regional_offerings
  end
end

File.open('./lib/tasks/management_consultancy/output/suppliers_with_service_offerings_and_regional_availability.json', 'w') do |f|
  f.write JSON.pretty_generate suppliers
end
