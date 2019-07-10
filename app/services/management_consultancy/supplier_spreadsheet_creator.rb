require 'axlsx'

class ManagementConsultancy::SupplierSpreadsheetCreator
  def initialize(suppliers, params)
    @suppliers = suppliers
    @params = params
  end

  def build
    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(name: 'Suppliers') do |sheet|
        sheet.add_row ['Supplier name', 'Contact name', 'Phone number', 'Email', 'Supplier average day rate (£)']
        add_supplier_details(sheet)
      end

      p.workbook.add_worksheet(name: 'Audit trail') do |sheet|
        sheet.add_row ['Lot', @params['lot']]
        add_audit_trail(sheet)
      end
    end
  end

  private

  def add_supplier_details(sheet)
    @suppliers.each do |supplier|
      rate_card = supplier.rate_cards.where(lot: @params['lot']).first
      sheet.add_row(
        [
          supplier.name,
          rate_card.contact_name,
          supplier.telephone_number,
          supplier.contact_email,
          rate_card.average_daily_rate
        ]
      )
    end
  end

  def add_audit_trail(sheet)
    services = []
    @params['services'].each do |service|
      services << ManagementConsultancy::Service.find_by(code: service).name
    end
    sheet.add_row ['Services', services.join(', ')]

    regions = []
    @params['region_codes'].each do |region_code|
      regions << Nuts2Region.find_by(code: region_code).name
    end
    sheet.add_row ['Regions', regions.join(', ')]
  end
end
