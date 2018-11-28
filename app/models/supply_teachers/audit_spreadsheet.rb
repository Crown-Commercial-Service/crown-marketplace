class SupplyTeachers::AuditSpreadsheet
  include TelephoneNumberHelper

  def to_xlsx
    package = Axlsx::Package.new
    workbook = package.workbook
    add_branch_worksheet(workbook)
    add_rate_worksheet(workbook)
    package.to_stream.read
  end

  private

  def add_branch_worksheet(workbook)
    workbook.add_worksheet(name: 'branches') do |sheet|
      sheet.add_row [
        'supplier.name',
        'postcode',
        'contact_name',
        'contact_email',
        'telephone_number',
        'name',
        'town'
      ]

      SupplyTeachers::Branch.all.find_each do |branch|
        sheet.add_row [
          branch.supplier.name,
          branch.postcode,
          branch.contact_name,
          branch.contact_email,
          format_telephone_number(branch.telephone_number),
          branch.name,
          branch.town
        ]
      end
    end
  end

  def add_rate_worksheet(workbook)
    workbook.add_worksheet(name: 'rates') do |sheet|
      sheet.add_row [
        'supplier.name',
        'job_type',
        'mark_up',
        'term',
        'lot_number',
        'daily_fee'
      ]

      SupplyTeachers::Rate.all.find_each do |rate|
        sheet.add_row [
          rate.supplier.name,
          rate.job_type,
          rate.mark_up,
          rate.term,
          rate.lot_number,
          rate.daily_fee
        ]
      end
    end
  end
end
