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

  class Shortlist < DataDownload
    def sheet_name
      'Supplier shortlist'
    end

    def headers
      extra_headers =
        ['Mark-up', 'Daily quote', 'Costs of the worker', 'Supplier fee']
      super + extra_headers
    end

    def row(branch, row)
      extra_fields =
        [branch.rate, '', formula(row, 'G#/(1+F#)'), formula(row, 'G#-H#')]
      super + extra_fields
    end

    def formula(row_num, formula)
      "=#{formula.gsub('#', row_num.to_s)}"
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

  def initialize(branches, with_calculations: false)
    @branches = branches
    @format = with_calculations ? Shortlist.new : DataDownload.new
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
