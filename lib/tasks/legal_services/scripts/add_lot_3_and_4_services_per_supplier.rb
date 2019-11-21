require 'roo'
require 'json'

# rubocop:disable Metrics/AbcSize

def add_lot_3_and_4_services_per_supplier
  suppliers = JSON.parse(File.read(get_ls_output_file_path('suppliers_with_lot_1_and_2_services.json')))

  lot_3_services = Roo::Spreadsheet.open(lot_3_file_path, extension: :xlsx)
  lot_4_services = Roo::Spreadsheet.open(lot_4_file_path, extension: :xlsx)

  lot_3_sheet = lot_3_services.sheet(0)
  lot_4_sheet = lot_4_services.sheet(0)

  (2..lot_3_sheet.last_column).each do |column_number|
    column = lot_3_sheet.column(column_number)
    supplier_duns = extract_duns(column.first)
    supplier = suppliers.find { |s| s['duns'] == supplier_duns }

    supplier['lots'] << { 'lot_number' => 3, 'services' => ['WPSLS.3.1'] }
  end

  (2..lot_4_sheet.last_column).each do |column_number|
    column = lot_4_sheet.column(column_number)
    supplier_duns = extract_duns(column.first)
    supplier = suppliers.find { |s| s['duns'] == supplier_duns }

    supplier['lots'] << { 'lot_number' => 4, 'services' => ['WPSLS.4.1'] }
  end

  write_ls_output_file('suppliers_with_all_services.json', suppliers)
end

# rubocop:enable Metrics/AbcSize

def extract_duns(supplier_name)
  supplier_name.split('[')[1].split(']')[0].to_i
end

def lot_3_file_path
  'storage/legal_services/current_data/input/lot3.xlsx'
end

def lot_4_file_path
  'storage/legal_services/current_data/input/lot4.xlsx'
end
