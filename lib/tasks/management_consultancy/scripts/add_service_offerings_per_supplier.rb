require 'roo'
require 'json'

def add_service_offerings_per_supplier
  suppliers = JSON.parse(File.read(Rails.root.join('storage', 'management_consultancy', 'current_data', 'output', 'suppliers.json')))
  suppliers.each { |supplier| supplier['lots'] = [] }

  service_offerings_workbook = Roo::Spreadsheet.open(Rails.root.join('storage', 'management_consultancy', 'current_data', 'input', 'Service offerings.xlsx'), extension: :xlsx)

  (0..10).each do |sheet_number|
    sheet = service_offerings_workbook.sheet(sheet_number)
    service_names = sheet.column(1)
    lot_number = extract_service_number(service_names[1]).match(/MCF\d[.]\d+/).to_s

    (2..sheet.last_column).each do |column_number|
      column = sheet.column(column_number)
      supplier_duns = extract_duns(column.first)
      service_offerings = []
      column.each_with_index do |value, index|
        next unless value.to_s.downcase == 'x'

        next if service_names[index].nil?

        next if zero_number_service_line?(service_names[index])

        service_offerings << extract_service_number(service_names[index])
      end

      next unless service_offerings.size.positive?

      supplier = suppliers.find { |s| s['duns'] == supplier_duns }
      supplier['lots'] << { 'lot_number' => lot_number, 'services' => service_offerings } if supplier
    end
  end

  File.open(Rails.root.join('storage', 'management_consultancy', 'current_data', 'output', 'suppliers_with_service_offerings.json'), 'w') do |f|
    f.write JSON.pretty_generate suppliers
  end
end

def extract_service_number(service_name)
  service_name.split('[')[1].split(']')[0]
end

def zero_number_service_line?(service_name)
  service_number = extract_service_number(service_name)
  /\.0\z/.match? service_number
end

def extract_duns(supplier_name)
  supplier_name.split('[')[1].split(']')[0].to_i
end
