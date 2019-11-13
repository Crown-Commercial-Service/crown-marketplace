require 'axlsx'
require 'axlsx_rails'

class FacilitiesManagement::DeliverableMatrixSpreadsheetCreator
  def initialize(building_ids_with_service_codes, units_of_measure_values = nil)
    @building_ids_with_service_codes = building_ids_with_service_codes
    building_ids = building_ids_with_service_codes.map { |h| h[:building_id] }
    @buildings = FacilitiesManagement::Buildings.where(id: building_ids)
    buildings_with_service_codes
    set_services
    @units_of_measure_values = units_of_measure_values
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

        unless @units_of_measure_values.nil?
          p.workbook.add_worksheet(name: 'Volume') do |sheet|
            add_header_row(sheet, ['Service Reference',	'Service Name',	'Metric',	'Unit of Measure'])
            add_volumes_information(sheet)
            style_volume_sheet(sheet, standard_column_style)
          end
        end
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
      building = @buildings.find(building_id_with_service_codes[:building_id])

      @buildings_with_service_codes << { building: building, service_codes: building_id_with_service_codes[:service_codes] }
    end

    # @buildings_with_service_codes.map!(&:deep_symbolize_keys!)
    @buildings_with_service_codes.each do |b|
      b[:building][:building_json].deep_symbolize_keys!
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
      row << building_with_service_codes[:building].building_json[:description]
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
    row = ['Building Gross Internal Area (GIA) (sqm)']

    @buildings_with_service_codes.each do |building_with_service_codes|
      row << building_with_service_codes[:building].building_json[:gia]
    end

    row
  end

  def building_type
    row = ['Building Type']

    @buildings_with_service_codes.each do |building_with_service_codes|
      row << building_with_service_codes[:building].building_json[:'building-type']
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

  def add_volumes_information(sheet)
    number_column_style = sheet.styles.add_style sz: 12, border: { style: :thin, color: '00000000' }, bg_color: 'FCFF40'

    @services.each do |s|
      new_row = [s['code'], s['name'], s['metric'], s['unit_text']]
      @buildings_with_service_codes.each do |b|
        uvs = @units_of_measure_values.select { |u| b[:building][:id] == u[:building_id] }

        suv = uvs.find { |u| s['code'] == u[:service_code] }

        new_row << suv[:uom_value] if suv
        new_row << nil unless suv
      end

      sheet.add_row new_row, style: number_column_style
    end
  end

  def style_volume_sheet(sheet, style)
    column_widths = [15, 100, 50, 50]
    @buildings.count.times { column_widths << 20 }
    sheet["A2:D#{@services.count + 1}"].each { |c| c.style = style }
    sheet.column_widths(*column_widths)
  end
end
