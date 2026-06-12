class FilesProcessor
  include FilesImporterHelper

  def initialize(upload)
    @upload = upload
    @supplier_data = []
  end

  def process_files
    self.class::PROCESS_FILES_AND_METHODS.each do |file, check_method|
      read_spreadsheet(file) do |workbook|
        send(check_method, workbook)
      end
    end

    clean_supplier_data_service_and_rates

    @supplier_data
  end

  private

  def add_suppliers(suppliers_workbook, headers, &)
    @supplier_data = suppliers_workbook.sheet(0).parse(headers).map(&)

    @suppliers_by_duns = @supplier_data.index_by { |s| s[:duns_number] }
  end

  def clean_supplier_data_service_and_rates
    @supplier_data.each do |supplier|
      supplier[:supplier_frameworks][0][:supplier_framework_lots_data].each do |lot_id, supplier_framework_lot_data|
        supplier[:supplier_frameworks][0][:supplier_framework_lots] << {
          lot_id: lot_id,
          enabled: supplier_framework_lot_data.fetch(:enabled, true),
          supplier_framework_lot_services: supplier_framework_lot_data[:services],
          supplier_framework_lot_jurisdictions: supplier_framework_lot_data[:jurisdictions],
          supplier_framework_lot_rates: supplier_framework_lot_data[:rates],
          supplier_framework_lot_branches: supplier_framework_lot_data[:branches],
        }
      end

      supplier[:supplier_frameworks][0].delete(:supplier_framework_lots_data)
    end
  end
end
