require 'roo'
require 'json'

# rubocop:disable Metrics/AbcSize

def add_lot_1_services_per_supplier
  lot_1_services = Roo::Spreadsheet.open(lot_1_file_path, extension: :xlsx)
  suppliers = JSON.parse(File.read(get_ls_output_file_path('suppliers.json')))
  suppliers.each { |supplier| supplier['lot_1_services'] = [] }

  (0..12).each do |sheet_number|
    sheet = lot_1_services.sheet(sheet_number)
    service_names = sheet.column(1)
    region_code = extract_nuts_code(sheet.default_sheet)

    (2..sheet.last_column).each do |column_number|
      column = sheet.column(column_number)
      supplier_duns = extract_duns(column.first)
      supplier = suppliers.find { |s| s['duns'] == supplier_duns }

      column.each_with_index do |value, index|
        next unless value.to_s.downcase == 'x'

        next if service_names[index].nil?

        supplier['lot_1_services'] << { 'service_code': extract_service_number(service_names[index]), 'region_code': region_code }
      end
    end
  end

  write_ls_output_file('suppliers_with_lot_1_services.json', suppliers)
end

# rubocop:enable Metrics/AbcSize

def extract_service_number(service_name)
  service_name.split('[')[1].split(']')[0]
end

def extract_duns(supplier_name)
  supplier_name.split('[')[1].split(']')[0].to_i
end

def extract_nuts_code(sheet_name)
  return 'UK' if sheet_name == 'Full UK Coverage'

  'UK' + sheet_name.split('(NUTS')[1].split(')')[0].strip
end

def lot_1_file_path
  'storage/legal_services/current_data/input/lot1.xlsx'
end
