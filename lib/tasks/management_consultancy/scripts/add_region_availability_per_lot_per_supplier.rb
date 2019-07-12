require 'roo'
require 'json'
require 'aws-sdk-s3'

def add_region_availability_per_lot_per_supplier
  suppliers = JSON.parse(File.read(get_mc_output_file_path('suppliers_with_service_offerings.json')))

  regional_offerings_workbook = Roo::Spreadsheet.open(regional_offerings_workbook_filepath, extension: :xlsx)

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

  (0..10).each do |sheet_number|
    sheet = regional_offerings_workbook.sheet(sheet_number)
    region_names = sheet.row(1)
    lot_number = sheet_names[sheet.default_sheet]

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

  write_output_file('suppliers_with_service_offerings_and_regional_availability.json', suppliers)
end

def nuts1_region?(region_name)
  region_code = extract_region_code(region_name)
  /\AUK.\z/.match?(region_code)
end

def extract_region_code(region_name)
  region_name.split('(')[1].split(')')[0]
end

def extract_duns(supplier_name)
  supplier_name.split('[')[1].split(']')[0].to_i
end

def regional_offerings_workbook_filepath
  ManagementConsultancy::Admin::Upload::SUPPLIER_REGIONAL_OFFERINGS_PATH
end
