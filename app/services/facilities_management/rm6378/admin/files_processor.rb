class FacilitiesManagement::RM6378::Admin::FilesProcessor < FilesProcessor
  private

  def add_suppliers(suppliers_workbook)
    super(
      suppliers_workbook,
      {
        name: 'Supplier name',
        sme: 'SME',
        duns: 'DUNS number',
        clean: true
      }
    ) do |supplier|
      {
        id: SecureRandom.uuid,
        name: supplier[:name],
        duns_number: supplier[:duns].to_i.to_s,
        sme: ['YES', 'Y'].include?(supplier[:sme].to_s.upcase),
        supplier_frameworks: [
          {
            framework_id: 'RM6378',
            enabled: true,
            supplier_framework_contact_detail: {},
            supplier_framework_lots_data: Hash.new { |h, k| h[k] = { services: [], rates: [], jurisdictions: [], branches: [] } },
            supplier_framework_lots: []
          }
        ]
      }
    end
  end

  def add_services_per_supplier(services_workbook)
    LOT_NUMBERS.each do |lot_number|
      sheet = services_workbook.sheet("Lot #{lot_number}")

      sheet_columns_and_rows = sheet.to_a.transpose

      service_codes = sheet_columns_and_rows[1][2..].map(&:to_s)

      sheet_columns_and_rows[2..].each do |column|
        supplier_duns = column[1].to_i.to_s
        supplier = get_supplier(supplier_duns)
        next unless supplier

        add_services(supplier, lot_number, service_codes, column)
      end
    end
  end

  def add_services(supplier, lot_number, service_codes, column)
    supplier_framework_lots_data = supplier[:supplier_frameworks][0][:supplier_framework_lots_data]

    column[2..].each_with_index do |value, index|
      next unless value.to_s.downcase == 'x'
      next unless service_codes[index].length > 1

      lot_id = "RM6378.#{lot_number}"
      service_id = "#{lot_id}.#{service_codes[index]}"

      supplier_framework_lots_data[lot_id][:services] << { service_id: }
    end
  end

  def add_regions_per_supplier(regions_workbook)
    LOT_NUMBERS.each do |lot_number|
      sheet = regions_workbook.sheet("Lot #{lot_number}")

      sheet_columns_and_rows = sheet.to_a.transpose

      region_codes = sheet_columns_and_rows[1][2..].map(&:to_s)

      sheet_columns_and_rows[2..].each do |column|
        supplier_duns = column[1].to_i.to_s
        supplier = get_supplier(supplier_duns)
        next unless supplier

        add_regions(supplier, lot_number, region_codes, column)
      end
    end
  end

  def add_regions(supplier, lot_number, region_codes, column)
    supplier_framework_lots_data = supplier[:supplier_frameworks][0][:supplier_framework_lots_data]

    column[2..].each_with_index do |value, index|
      next unless value.to_s.downcase == 'x'
      next unless region_codes[index].length > 3

      lot_id = "RM6378.#{lot_number}"

      supplier_framework_lots_data[lot_id][:jurisdictions] << { jurisdiction_id: "RM6378.#{region_codes[index]}" }
    end
  end

  LOT_NUMBERS = ['1a', '1b', '1c', '2a', '2b', '3a', '3b', '4a', '4b', '4c', '4d'].freeze

  PROCESS_FILES_AND_METHODS = {
    supplier_details_file: :add_suppliers,
    supplier_services_file: :add_services_per_supplier,
    supplier_regions_file: :add_regions_per_supplier,
  }.freeze
end
