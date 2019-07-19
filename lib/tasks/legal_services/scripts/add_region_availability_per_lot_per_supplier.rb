require 'roo'
require 'json'

# rubocop:disable Metrics/AbcSize
def add_region_availability_per_lot_per_supplier
  suppliers = JSON.parse(File.read('/users/milomia/master/storage/legal_services/current_data/output/suppliers2.json'))

  workbook = Roo::Spreadsheet.open '/users/milomia/master/storage/legal_services/current_data/input/Regional offerings.xlsx'

  workbook.sheets.each do |sheet_name|
    sheet = workbook.sheet(sheet_name)
    region_names = sheet.row(1)
    lot_number = 1

    (2..sheet.last_row).each do |row_number|
      row = sheet.row(row_number)
      supplier_duns = extract_duns(row.first)
      regional_offerings = {}
      row.each_with_index do |value, index|
        next unless value.to_s.downcase == 'x'

        next if nuts1_region?(region_names[index])

        regional_offerings[extract_region_code(region_names[index])] = 'provided'
      end

      next unless regional_offerings.size.positive?

      supplier = suppliers.find { |s| s['duns'] == supplier_duns }
      if supplier
        supplier_lot = supplier['lots'].detect { |lot| lot['lot_number'] == lot_number }
        supplier_lot['regions'] = regional_offerings if supplier_lot
      end
    end
  end

  File.open('/users/milomia/master/storage/legal_services/current_data/regional_availability.json', 'w') do |f|
    f.write JSON.pretty_generate suppliers
  end
end

def nuts1_region?(region_name)
  region_code = extract_region_code(region_name)
  /\AUK.\z/.match?(region_code)
end

def extract_region_code(region_name)
  # region_name.split('(')[1].split(')')[0]
end

def extract_duns(supplier_name)
  supplier_name.split('[')[1].split(']')[0].to_i
end
# rubocop:enable Metrics/AbcSize

add_region_availability_per_lot_per_supplier
