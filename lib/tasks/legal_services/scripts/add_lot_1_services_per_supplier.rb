require 'roo'
require 'json'

# rubocop:disable Metrics/AbcSize

def add_lot_1_services_per_supplier(upload_id)
  upload = LegalServices::Admin::Upload.find(upload_id)

  lot_1_services = Roo::Spreadsheet.open upload.supplier_lot_1_service_offerings.file
  suppliers = upload.data
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

  upload.data = suppliers
  upload.save!
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
