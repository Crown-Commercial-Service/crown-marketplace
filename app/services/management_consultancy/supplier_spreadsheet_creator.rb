require 'axlsx'

class ManagementConsultancy::SupplierSpreadsheetCreator
  def initialize(suppliers, params)
    @suppliers = suppliers
    @params = params
  end

  def build
    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(name: 'Supplier shortlist') do |sheet|
        sheet.add_row ['Supplier name', 'Contact name', 'Phone number', 'Email']
        add_supplier_details(sheet)
      end

      p.workbook.add_worksheet(name: 'Shortlist audit') do |sheet|
        lot = ManagementConsultancy::Lot.find_by(number: @params['lot'])
        sheet.add_row ['Lot', "#{lot.number} - #{lot.description}"]
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
          supplier.contact_email
        ]
      )
    end
  end

  def add_audit_trail(sheet)
    services = []
    @params['services'].each do |service|
      if service =~ /^MCF\d[.]\d+[.]\d+[.]\d$/
        subservice =  ManagementConsultancy::Subservice.find_by(code: service)
        parent_service = ManagementConsultancy::Service.find_by(code: subservice.service)
        services << "#{parent_service.name} - #{subservice.name}"
      else
        services << ManagementConsultancy::Service.find_by(code: service).name
      end
    end
    sheet.add_row ['Services', services.join(', ')]

    regions = []
    @params['region_codes'].each do |region_code|
      regions << Nuts2Region.find_by(code: region_code).name
    end
    sheet.add_row ['Regions', regions.join(', ')]
  end
end
