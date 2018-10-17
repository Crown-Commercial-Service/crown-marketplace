class Spreadsheet
  class DataDownload
    def sheet_name
      'Suppliers'
    end

    def headers
      ['Supplier name', 'Branch name', 'Contact name', 'Contact email', 'Telephone number']
    end

    def row(branch, _row_num)
      [branch.supplier_name,
       branch.name,
       branch.contact_name,
       branch.contact_email,
       branch.telephone_number]
    end

    def style(workbook, sheet); end
  end

  class Shortlist
    def sheet_name
      'Supplier shortlist'
    end

    def headers
      ['Supplier name', 'Branch name', 'Contact name',
       'Contact email', 'Telephone number', 'Rate',
       'Daily quote',
       'Costs of the worker', 'Supplier fee']
    end

    def row(branch, row_num)
      [branch.supplier_name,
       branch.name,
       branch.contact_name,
       branch.contact_email,
       branch.telephone_number,
       branch.rate,
       '',
       "=G#{row_num}/(1+F#{row_num})",
       "=G#{row_num}-H#{row_num}"]
    end

    def style(workbook, sheet)
      workbook.styles do |s|
        percent = s.add_style(format_code: '00%')
        money = s.add_style(format_code: '[$£-809]##,##0.00')
        sheet.col_style 5, percent
        sheet.col_style 6, money
        sheet.col_style 7, money
        sheet.col_style 8, money
        sheet.column_widths(*Array.new(headers.length))
      end
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
      yield workbook, sheet
    end
    package.to_stream.read
  end

  def to_xlsx
    spreadsheet(@format.sheet_name) do |workbook, sheet|
      sheet.add_row @format.headers
      @branches.each.with_index(2) do |branch, i|
        sheet.add_row @format.row(branch, i)
      end
      @format.style(workbook, sheet)
    end
  end
end
