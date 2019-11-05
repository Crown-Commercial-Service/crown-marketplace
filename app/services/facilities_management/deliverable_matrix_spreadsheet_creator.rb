require 'axlsx'
require 'axlsx_rails'

class FacilitiesManagement::DeliverableMatrixSpreadsheetCreator
  def initialize(building_ids_with_service_codes, buildings = nil, uvals = nil)
    @building_ids_with_service_codes = building_ids_with_service_codes
    building_ids = building_ids_with_service_codes.map { |h| h[:building_id] }

    @uvals = uvals

    @buildings = buildings || FacilitiesManagement::Buildings.where(id: building_ids)

    if buildings
      buildings_with_service_codes_simple
    else
      buildings_with_service_codes
    end

    set_services
  end

  def build
    Axlsx::Package.new do |p|
      p.workbook.styles do |s|
        first_column_style = s.add_style sz: 12, b: true, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }
        standard_column_style = s.add_style sz: 12, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }

        p.workbook.add_worksheet(name: 'Buildings information') do |sheet|
          add_header_row(sheet, ['Buildings information'])
          add_buildings_information(sheet)
          style_buildings_information_sheet(sheet, first_column_style)
        end

        p.workbook.add_worksheet(name: 'Service Matrix') do |sheet|
          add_header_row(sheet, ['Service Reference', 'Service Name'])
          add_service_matrix(sheet)
          style_service_matrix_sheet(sheet, standard_column_style)
        end

        volumes_sheet p
      end
    end
  end

  private

  def standard_row_height
    35
  end

  def add_header_row(sheet, initial_values)
    header_row_style = sheet.styles.add_style sz: 12, b: true, alignment: { wrap_text: true, horizontal: :center, vertical: :center }, border: { style: :thin, color: '00000000' }
    header_row = initial_values
    (1..@buildings_with_service_codes.count).each { |x| header_row << "Building #{x}" }
    sheet.add_row header_row, style: header_row_style, height: standard_row_height
  end

  def style_buildings_information_sheet(sheet, style)
    sheet['A1:A10'].each { |c| c.style = style }
    sheet.column_widths(*([50] * sheet.column_info.count))
  end

  def style_service_matrix_sheet(sheet, style)
    column_widths = [15, 100]
    @buildings.count.times { column_widths << 50 }
    sheet["A2:B#{@services.count + 1}"].each { |c| c.style = style }
    sheet.column_widths(*column_widths)
  end

  def buildings_with_service_codes
    @buildings_with_service_codes = []

    @building_ids_with_service_codes.each do |building_id_with_service_codes|
      building = @buildings.find(id: building_id_with_service_codes[:building_id])

      @buildings_with_service_codes << { building: building, service_codes: building_id_with_service_codes[:service_codes] }
    end
  end

  def buildings_with_service_codes_simple
    @buildings_with_service_codes = []

    @building_ids_with_service_codes.each do |building_id_with_service_codes|
      building = @buildings.find { |b| b[:id] == building_id_with_service_codes[:building_id] }

      @buildings_with_service_codes << { building: building, service_codes: building_id_with_service_codes[:service_codes] }
    end
  end

  def set_services
    service_codes = []

    @buildings_with_service_codes.each do |building_with_service_codes|
      service_codes += building_with_service_codes[:service_codes]
    end

    services = FacilitiesManagement::StaticData.work_packages.select { |wp| service_codes.uniq.include? wp['code'] }
    @services = services.sort { |a, b| [a['code'].split('.')[0], a['code'].split('.')[1].to_i] <=> [b['code'].split('.')[0], b['code'].split('.')[1].to_i] }
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
      row << building_with_service_codes[:building].building_json[:name]
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
      row << building_with_service_codes[:building].building_json[:address][:'fm-address-line-1']
    end

    row
  end

  def building_address_town
    row = ['Building Address - Town']

    @buildings_with_service_codes.each do |building_with_service_codes|
      row << building_with_service_codes[:building].building_json[:address][:'fm-address-town']
    end

    row
  end

  def building_address_postcode
    row = ['Building Address - Postcode']

    @buildings_with_service_codes.each do |building_with_service_codes|
      row << building_with_service_codes[:building].building_json[:address][:'fm-address-postcode']
    end

    row
  end

  def building_nuts_region
    row = ['Building Location (NUTS Region)']

    @buildings_with_service_codes.each do |building_with_service_codes|
      row << building_with_service_codes[:building].building_json[:address][:'fm-nuts-region']
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
      row << building_with_service_codes[:building].building_json[:'security-type']
    end

    row
  end

  def add_service_matrix(sheet)
    standard_style = sheet.styles.add_style sz: 12, border: { style: :thin, color: '00000000' }, bg_color: 'FCFF40', alignment: { wrap_text: true, vertical: :center, horizontal: :center }, fg_color: '6E6E6E'

    @services.each do |service|
      row_values = [service['code'], service['name']]

      @building_ids_with_service_codes.each do |building|
        v = building[:service_codes].include?(service['code']) ? 'Yes' : ''
        row_values << v
      end

      sheet.add_row row_values, style: standard_style, height: standard_row_height
    end
  end

  def volumes_sheet(pkg)
    pkg.workbook.add_worksheet(name: 'Volume') do |sheet|
      add_header_row(sheet, ['Service Reference',	'Service Name',	'Metric',	'Unit of Measure'])
      # add_service_matrix(sheet)
      # style_service_matrix_sheet(sheet, standard_column_style)

      codes = @building_ids_with_service_codes.collect do |building|
        building[:service_codes]
      end

      codes.flatten!.uniq!

      services = FacilitiesManagement::StaticData.work_packages.map { |w| [w['code'], w] }.to_h
      codes.sort_by { |code| [code[0..code.index('.') - 1], code[code.index('.') + 1..-1].to_i] }.each do |s|
        sheet.add_row [s, services[s]['description']]
      end
    end
  end
end
