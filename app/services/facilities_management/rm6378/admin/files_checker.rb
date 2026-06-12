class FacilitiesManagement::RM6378::Admin::FilesChecker
  include FilesImporterHelper

  def initialize(upload)
    @upload = upload
    @errors = []
  end

  def check_files
    CHECK_FILES_AND_METHODS.each do |file, check_method|
      read_spreadsheet(file) do |workbook|
        send(check_method, workbook)
      end
    end

    @errors
  end

  private

  def check_supplier_details_spreadsheet(suppliers_workbook)
    if suppliers_workbook.sheets != ['RM6378 Suppliers Details']
      @errors << { error: 'supplier_details_missing_sheets' }
    elsif suppliers_workbook.sheet(0).row(1) != ['Supplier name', 'SME', 'DUNS number']
      @errors << { error: 'supplier_details_has_incorrect_headers' }
    elsif suppliers_workbook.sheet(0).last_row == 1
      @errors << { error: 'supplier_details_has_empty_sheets' }
    end
  end

  def check_supplier_services_file_spreadsheet(services_workbook)
    check_sheets(services_workbook, SHEETS.pluck(:sheet_name), 'supplier_services') do |sheets_with_errors, empty_sheets, index|
      current_sheet = SHEETS[index]

      if services_workbook.sheet(index).last_row != current_sheet[:last_row]
        sheets_with_errors << current_sheet[:sheet_name]
      elsif services_workbook.sheet(index).last_column == 2
        empty_sheets << current_sheet[:sheet_name]
      end
    end
  end

  def check_supplier_regions_file_spreadsheet(regions_workbook)
    check_sheets(regions_workbook, SHEETS.pluck(:sheet_name), 'supplier_regions') do |sheets_with_errors, empty_sheets, index|
      current_sheet = SHEETS[index]

      if regions_workbook.sheet(index).last_row != 109
        sheets_with_errors << current_sheet[:sheet_name]
      elsif regions_workbook.sheet(index).last_column == 2
        empty_sheets << current_sheet[:sheet_name]
      end
    end
  end

  SHEETS = [
    {
      sheet_name: 'Lot 1a',
      last_row: 155
    },
    {
      sheet_name: 'Lot 1b',
      last_row: 155
    },
    {
      sheet_name: 'Lot 1c',
      last_row: 155
    },
    {
      sheet_name: 'Lot 2a',
      last_row: 51
    },
    {
      sheet_name: 'Lot 2b',
      last_row: 51
    },
    {
      sheet_name: 'Lot 3a',
      last_row: 92
    },
    {
      sheet_name: 'Lot 3b',
      last_row: 92
    },
    {
      sheet_name: 'Lot 4a',
      last_row: 32
    },
    {
      sheet_name: 'Lot 4b',
      last_row: 12
    },
    {
      sheet_name: 'Lot 4c',
      last_row: 12
    },
    {
      sheet_name: 'Lot 4d',
      last_row: 12
    }
  ].freeze

  CHECK_FILES_AND_METHODS = {
    supplier_details_file: :check_supplier_details_spreadsheet,
    supplier_services_file: :check_supplier_services_file_spreadsheet,
    supplier_regions_file: :check_supplier_regions_file_spreadsheet,
  }.freeze
end
