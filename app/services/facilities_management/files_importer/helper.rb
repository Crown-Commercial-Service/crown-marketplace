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
end
