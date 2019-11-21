require 'roo'
require 'json'

# rubocop:disable Metrics/AbcSize

def add_lot_2_services_per_supplier
  lot_2_services = Roo::Spreadsheet.open(lot_2_file_path, extension: :xlsx)
  suppliers = JSON.parse(File.read(get_ls_output_file_path('suppliers_with_lot_1_services.json')))
  suppliers.each { |supplier| supplier['lots'] = [] }

  (0..2).each do |sheet_number|
    sheet = lot_2_services.sheet(sheet_number)
    lot_number = extract_lot_number(sheet.default_sheet)
    service_names = sheet.column(1)

    (2..sheet.last_column).each do |column_number|
      column = sheet.column(column_number)
      supplier_duns = extract_duns(column.first)
      supplier = suppliers.find { |s| s['duns'] == supplier_duns }
      service_codes = []

      column.each_with_index do |value, index|
        next unless value.to_s.downcase == 'x'

        next if service_names[index].nil?

        service_codes << extract_service_number(service_names[index])
      end

      supplier['lots'] << { 'lot_number' => lot_number, 'services' => service_codes } if supplier
    end
  end

  write_ls_output_file('suppliers_with_lot_1_and_2_services.json', suppliers)
end

# rubocop:enable Metrics/AbcSize

def extract_lot_number(sheet_name)
  sheet_name.split('Lot')[1].split('-')[0].strip
end

def extract_service_number(service_name)
  service_name.split('[')[1].split(']')[0]
end

def extract_duns(supplier_name)
  supplier_name.split('[')[1].split(']')[0].to_i
end

def lot_2_file_path
  'storage/legal_services/current_data/input/lot2.xlsx'
end
