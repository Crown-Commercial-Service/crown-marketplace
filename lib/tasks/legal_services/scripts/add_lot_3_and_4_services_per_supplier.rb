require 'roo'
require 'json'

# rubocop:disable Metrics/AbcSize

def add_lot_3_and_4_services_per_supplier(upload_id)
  upload = LegalServices::Admin::Upload.find(upload_id)
  suppliers = upload.data

  lot_3_services = Roo::Spreadsheet.open upload.supplier_lot_3_service_offerings.url
  lot_4_services = Roo::Spreadsheet.open upload.supplier_lot_4_service_offerings.url

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

  upload.data = suppliers

  upload.save!
end

# rubocop:enable Metrics/AbcSize

def extract_duns(supplier_name)
  supplier_name.split('[')[1].split(']')[0].to_i
end
