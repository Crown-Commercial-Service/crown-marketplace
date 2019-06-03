require 'roo'
require 'json'

suppliers = JSON.parse(File.read('./lib/tasks/management_consultancy/output/suppliers_with_service_offerings_and_regional_availability.json'))
suppliers.each { |supplier| supplier['rate_cards'] = [] }

rate_cards_workbook = Roo::Spreadsheet.open './lib/tasks/management_consultancy/input/rate_cards.xlsx'

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

def convert_price(price)
  price.to_s.gsub(',', '').to_i * 100
end

def extract_duns(supplier_name)
  supplier_name.split('[')[1].split(']')[0].to_i
end

(0..10).each do |sheet_number|
  sheet = rate_cards_workbook.sheet(sheet_number)
  lot_number = sheet_names[sheet.default_sheet]

  (2..sheet.last_row).each do |row_number|
    row = sheet.row(row_number)
    supplier_duns = extract_duns(row.first)
    supplier = suppliers.find { |s| s['duns'] == supplier_duns }
    rate_card = {}
    rate_card['lot_number'] = lot_number
    rate_card['junior_rate_in_pence'] = convert_price(row[1])
    rate_card['standard_rate_in_pence'] = convert_price(row[2])
    rate_card['senior_rate_in_pence'] = convert_price(row[3])
    rate_card['principal_rate_in_pence'] = convert_price(row[4])
    rate_card['managing_rate_in_pence'] = convert_price(row[5])
    rate_card['director_rate_in_pence'] = convert_price(row[6])
    rate_card['contact_name'] = row[7]
    rate_card['email'] = row[8]
    rate_card['telephone_number'] = row[9]

    supplier['rate_cards'] << rate_card if supplier
  end
end

File.open('./lib/tasks/management_consultancy/output/suppliers_with_service_offerings_and_regional_availability_and_rate_cards.json', 'w') do |f|
  f.write JSON.pretty_generate suppliers
end
