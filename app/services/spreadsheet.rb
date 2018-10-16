class Spreadsheet
  def initialize(branches)
    @branches = branches
  end

  def to_xlsx
    package = Axlsx::Package.new
    workbook = package.workbook
    workbook.add_worksheet(name: 'Suppliers') do |sheet|
      sheet.add_row ['Supplier name', 'Branch name', 'Contact name', 'Contact email', 'Telephone number']
      @branches.each do |branch|
        sheet.add_row [
          branch.supplier.name,
          branch.name,
          branch.contact_name,
          branch.contact_email,
          branch.telephone_number
        ]
      end
    end
    package.to_stream.read
  end
end
