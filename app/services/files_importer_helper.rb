module FilesImporterHelper
  def read_spreadsheet(file)
    workbook = current_spreadsheet(file)

    yield(workbook)

    workbook.close
  end

  def current_spreadsheet(file)
    tmpfile = Tempfile.create
    tmpfile.binmode
    tmpfile.write @upload.send(file).download
    tmpfile.close

    Roo::Spreadsheet.open(tmpfile.path, extension: :xlsx)
  end

  def check_sheets(workbook, expected_sheets, attribute)
    if workbook.sheets == expected_sheets
      sheets_with_errors = []
      empty_sheets = []

      number_of_sheets(workbook).times do |index|
        yield(sheets_with_errors, empty_sheets, index)
      end

      @errors << { error: "#{attribute}_has_incorrect_headers", details: sheets_with_errors } if sheets_with_errors.any?
      @errors << { error: "#{attribute}_has_empty_sheets", details: empty_sheets } if empty_sheets.any?
    else
      @errors << { error: "#{attribute}_missing_sheets" }
    end
  end

  def get_supplier(supplier_duns)
    @suppliers_by_duns[supplier_duns]
  end

  def get_supplier_by_additional_identifier(additional_identifier)
    @supplier_data.find { |s| s[:additional_details][:additional_identifier] == additional_identifier }
  end

  def extract_duns(supplier_name)
    supplier_name[/(?<=\[)(.*?)(?=\])/].to_i.to_s
  end

  def extract_region_code(region_name)
    region_name[/(?<=\()(.*?)(?=\))/]
  end

  def extract_service_number(service_name)
    service_name[/(?<=\[)(.*?)(?=\])/]
  end

  def number_of_sheets(workbook)
    workbook.sheets.size
  end
end
