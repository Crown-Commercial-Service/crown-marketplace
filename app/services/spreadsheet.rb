class Spreadsheet
  class DataDownload
    def sheet_name
      'Suppliers'
    end

    def headers
      ['Supplier name', 'Branch name', 'Contact name', 'Contact email', 'Telephone number']
    end

    def row(branch)
      [branch.supplier_name,
       branch.name,
       branch.contact_name,
       branch.contact_email,
       branch.telephone_number]
    end
  end

  def initialize(branches, format = DataDownload.new)
    @branches = branches
    @format = format
  end

  def spreadsheet(name)
    package = Axlsx::Package.new
    workbook = package.workbook
    workbook.add_worksheet(name: name) do |sheet|
      yield sheet
    end
    package.to_stream.read
  end

  def to_xlsx
    spreadsheet(@format.sheet_name) do |sheet|
      sheet.add_row @format.headers
      @branches.each do |branch|
        sheet.add_row @format.row(branch)
      end
    end
  end
end
