require 'axlsx'
require 'axlsx_rails'

class FacilitiesManagement::DeliverableMatrixSpreadsheetCreator
  def initialize(building_ids_with_service_codes)
    @building_ids_with_service_codes = building_ids_with_service_codes
    building_ids = building_ids_with_service_codes.map { |h| h[:building_id] }
    @buildings = FacilitiesManagement::Buildings.where(id: building_ids)
    buildings_with_service_codes
    set_services
  end

  def build
    Axlsx::Package.new do |p|
      p.workbook.styles do |s|
        header_row_style =  s.add_style sz: 12, b: true, alignment: { horizontal: :center, vertical: :center }, border: { style: :thin, color: '00000000' }
        first_column_style = s.add_style sz: 12, b: true, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }

        p.workbook.add_worksheet(name: 'Buildings information') do |sheet|
          header_row = ['Buildings information']
          (1..@buildings_with_service_codes.count).each { |x| header_row << "Building #{x}" }
          sheet.add_row header_row, style: header_row_style, height: standard_row_height
          add_buildings_information(sheet)
          sheet['A1:A10'].each { |c| c.style = first_column_style }
          sheet.column_widths(*([50] * sheet.column_info.count))
        end
      end
    end
  end

  private

  def standard_row_height
    35
  end

  def buildings_with_service_codes
    @buildings_with_service_codes = []

    @building_ids_with_service_codes.each do |building_id_with_service_codes|
      building = @buildings.find(building_id_with_service_codes[:building_id])

      @buildings_with_service_codes << { building: building, service_codes: building_id_with_service_codes[:service_codes] }
    end
  end

  def set_services
    service_codes = []

    @buildings_with_service_codes.each do |building_with_service_codes|
      service_codes += building_with_service_codes[:service_codes]
    end

    @services = FacilitiesManagement::StaticData.work_packages.select { |wp| service_codes.uniq.include? wp['code'] }.sort_by { |wp| wp['code'] }
  end

  def add_buildings_information(sheet)
    standard_style = sheet.styles.add_style sz: 12, border: { style: :thin, color: '00000000' }, bg_color: 'FCFF40', alignment: { wrap_text: true, vertical: :center }, fg_color: '6E6E6E'

    [building_name, building_description, building_address_street, building_address_town, building_address_postcode, building_nuts_region, building_gia, building_type, building_security_clearance].each do |row_type|
      sheet.add_row row_type, style: standard_style, height: standard_row_height
    end
  end

  def building_name
    row = ['Building Name']

    @buildings_with_service_codes.each do |building_with_service_codes|
      row << building_with_service_codes[:building].building_json['name']
    end

    row
  end

  def building_description
    row = ['Building Description']

    @buildings_with_service_codes.each do |building_with_service_codes|
      row << building_with_service_codes[:building].building_json['description']
    end

    row
  end

  def building_address_street
    row = ['Building Address - Street']

    @buildings_with_service_codes.each do |building_with_service_codes|
      row << building_with_service_codes[:building].building_json['address']['fm-address-line-1']
    end

    row
  end

  def building_address_town
    row = ['Building Address - Town']

    @buildings_with_service_codes.each do |building_with_service_codes|
      row << building_with_service_codes[:building].building_json['address']['fm-address-town']
    end

    row
  end

  def building_address_postcode
    row = ['Building Address - Postcode']

    @buildings_with_service_codes.each do |building_with_service_codes|
      row << building_with_service_codes[:building].building_json['address']['fm-address-postcode']
    end

    row
  end

  def building_nuts_region
    row = ['Building Location (NUTS Region)']

    @buildings_with_service_codes.each do |building_with_service_codes|
      row << building_with_service_codes[:building].building_json['address']['fm-nuts-region']
    end

    row
  end

  def building_gia
    row = ['Building Gross Internal Area (GIA) (m2)']

    @buildings_with_service_codes.each do |building_with_service_codes|
      row << building_with_service_codes[:building].building_json['gia']
    end

    row
  end

  def building_type
    row = ['Building Type']

    @buildings_with_service_codes.each do |building_with_service_codes|
      row << building_with_service_codes[:building].building_json['building-type']
    end

    row
  end

  def building_security_clearance
    row = ['Building Security Clearance']

    @buildings_with_service_codes.each do |building_with_service_codes|
      row << building_with_service_codes[:building].building_json['security-type']
    end

    row
  end
end
