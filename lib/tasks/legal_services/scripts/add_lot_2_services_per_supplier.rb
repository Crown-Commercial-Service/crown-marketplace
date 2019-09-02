require 'roo'
require 'json'

# rubocop:disable Metrics/AbcSize

def add_lot_2_services_per_supplier(upload_id)
  upload = LegalServices::Admin::Upload.find(upload_id)

  lot_2_services = Roo::Spreadsheet.open(file_path(upload.supplier_lot_2_service_offerings))
  suppliers = upload.data
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

  upload.data = suppliers
  upload.save!
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

def file_path(file)
  return file.path if Rails.env.development?

  file.url
end
