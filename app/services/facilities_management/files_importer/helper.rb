module FacilitiesManagement::FilesImporter::Helper
  def read_spreadsheet(file)
    workbook = current_spreadsheet(file)

    yield(workbook)

    workbook.close
  end

  def current_spreadsheet(file)
    if @upload
      tmpfile = Tempfile.create
      tmpfile.binmode
      tmpfile.write @upload.send(file).download
      tmpfile.close

      Roo::Spreadsheet.open(tmpfile.path, extension: :xlsx)
    else
      Roo::Spreadsheet.open(@files_importer.file_sources(file), extension: :xlsx)
    end
  end

  # def check_sheets(workbook, expected_sheets, attribute)
  #   if workbook.sheets != expected_sheets
  #     @errors << { error: "#{attribute}_missing_sheets" }
  #   else
  #     sheets_with_errors = []
  #     empty_sheets = []

  #     number_of_sheets(workbook).times do |index|
  #       yield(sheets_with_errors, empty_sheets, index)
  #     end

  #     @errors << { error: "#{attribute}_has_incorrect_headers", details: sheets_with_errors } if sheets_with_errors.any?
  #     @errors << { error: "#{attribute}_has_empty_sheets", details: empty_sheets } if empty_sheets.any?
  #   end
  # end

  # def get_supplier(supplier_duns)
  #   @supplier_data.find { |s| s['duns'] == supplier_duns }
  # end

  # def number_of_sheets(workbook)
  #   workbook.sheets.size
  # end
end
