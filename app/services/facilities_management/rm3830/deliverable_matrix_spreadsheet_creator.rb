class FacilitiesManagement::RM3830::DeliverableMatrixSpreadsheetCreator
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::TextHelper
  include FacilitiesManagement::ContractDatesHelper

  def buildings_data
    @buildings_data ||= @active_procurement_buildings.map { |b| { building_id: b.building_id, service_codes: b.service_codes } }
  end

  # rubocop:disable Metrics/AbcSize
  def services_data
    uniq_buildings_service_codes ||= buildings_data.pluck(:service_codes).flatten.uniq
    services ||= FacilitiesManagement::RM3830::StaticData.work_packages.select { |wp| uniq_buildings_service_codes.include? wp['code'] }
    @services_data ||= services.sort { |a, b| [a['code'].split('.')[0], a['code'].split('.')[1].to_i] <=> [b['code'].split('.')[0], b['code'].split('.')[1].to_i] }
  end
  # rubocop:enable Metrics/AbcSize

  def to_xlsx
    @package.to_stream.read
  end

  private

  ##### Methods regarding the building of the 'Buildings information' worksheet #####
  def add_buildings_worksheet(package, first_column_style)
    package.workbook.add_worksheet(name: 'Buildings information') do |sheet|
      add_header_row(sheet, ['Buildings information'])
      add_building_name_row(sheet, ['Building name'], :left)
      add_buildings_information(sheet)
      style_buildings_information_sheet(sheet, first_column_style)
    end
  end

  BUILDING_TITLES_AND_ATTRIBUTES =
    {
      'Building Description': :description,
      'Building Address - Line 1': :address_line_1,
      'Building Address - Line 2': :address_line_2,
      'Building Address - Town': :address_town,
      'Building Address - Postcode': :address_postcode,
      'Building Location (NUTS Region)': :address_region,
      'Building Gross Internal Area (GIA) (sqm)': :gia,
      'Building External Area (sqm)': :external_area,
      'Building Type': :building_type,
      'Building Type (other)': :other_building_type,
      'Building Security Clearance': :security_type,
      'Building Security Clearance (other)': :other_security_type
    }.freeze

  def add_buildings_information(sheet)
    standard_style = sheet.styles.add_style sz: 12, border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center, horizontal: :left }

    BUILDING_TITLES_AND_ATTRIBUTES.each do |title, attribute|
      sheet.add_row building_row(title.to_s, attribute), style: standard_style, height: standard_row_height
    end
  end

  def building_row(title, attribute)
    [title] + @active_procurement_buildings.map { |building| sanitize_string_for_excel(building[attribute].to_s) }
  end

  ##### Methods regarding the building of the 'Service Periods' worksheet #####
  def add_service_periods_worksheet(package, standard_column_style, units)
    package.workbook.add_worksheet(name: 'Service Periods') do |sheet|
      hint_style = sheet.styles.add_style sz: 12, border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center, horizontal: :left }, fg_color: '6E6E6E'
      hint_center_style = sheet.styles.add_style sz: 12, border: { style: :thin, color: '00000000' }, alignment: { vertical: :center, horizontal: :center }, fg_color: '6E6E6E'

      add_header_row(sheet, ['Service Reference', 'Service Name', 'Metric per Annum'])
      add_building_name_row(sheet, ['', '', ''], :center)
      add_service_periods(sheet, units)
      style_service_periods_matrix_sheet(sheet, standard_column_style, hint_style, hint_center_style) if sheet.rows.size > 1
    end
  end

  def add_service_periods(sheet, units)
    standard_style = sheet.styles.add_style sz: 12, border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center, horizontal: :left }

    services_requiring_hours = hours_required_services
    services_requiring_hours.each_with_index do |service, index|
      data_for_service = data_for_service_code(units, service['code'])

      add_service_hour_row(sheet, service, buildings_data, data_for_service, standard_style)
      add_detail_of_requirement_row(sheet, service, buildings_data, data_for_service, standard_style)
      add_break_row(sheet, index, services_requiring_hours.size - 1)
    end
  end

  def hours_required_services
    allowed_services = []
    FacilitiesManagement::RM3830::StaticData.work_packages.select { |work_package| allowed_services << work_package['code'] if work_package['metric'] == 'Number of hours required' }
    services_data.select { |service| allowed_services.include? service['code'] }
  end

  def add_service_hour_row(sheet, service, buildings_data, data_for_service, standard_style)
    row_values = [service['code'], service['name'], 'Number of hours required']
    row_values += service_hour_row(buildings_data, data_for_service)

    sheet.add_row row_values, style: standard_style, height: standard_row_height
  end

  def service_hour_row(buildings_data, data_for_service)
    buildings_data.map do |building|
      service_measure = find_service_for_building(data_for_service, building[:building_id])

      if service_measure.nil?
        ''
      else
        service_measure[:uom_value]
      end
    end
  end

  def add_detail_of_requirement_row(sheet, service, buildings_data, data_for_service, standard_style)
    row_values = [service['code'], service['name'], 'Detail of requirement']
    row_values += detail_of_requirement_row(buildings_data, data_for_service)

    sheet.add_row row_values, style: standard_style
  end

  def detail_of_requirement_row(buildings_data, data_for_service)
    buildings_data.map do |building|
      service_measure = find_service_for_building(data_for_service, building[:building_id])

      if service_measure.nil?
        ''
      else
        sanitize_string_for_excel(service_measure[:detail_of_requirement])
      end
    end
  end

  def add_break_row(sheet, index, max)
    sheet.add_row [], height: standard_row_height if index < max
  end

  ##### Methods regarding the building of the 'Customer & Contract Details' worksheet #####
  def add_contract_requirements(sheet)
    bold_style = sheet.styles.add_style b: true
    sheet.add_row []
    sheet.add_row ['2. Contract requirements'], style: bold_style
    add_initial_call_off_period(sheet)
    add_mobilisation_period(sheet)
    sheet.add_row ['Date of First Indexation', @procurement.initial_call_off_period < 1.year ? 'Not applicable' : (@procurement.initial_call_off_start_date + 1.year).strftime('%d/%m/%Y')]
    add_extension_periods(sheet)
    add_tupe(sheet)
  end

  def add_mobilisation_period(sheet)
    sheet.add_row ['Mobilisation Period', (mobilisation_period if @procurement.mobilisation_period_required)]
    sheet.add_row ['Mobilisation Start Date', (@procurement.mobilisation_start_date.strftime('%d/%m/%Y') if @procurement.mobilisation_period_required)]
    sheet.add_row ['Mobilisation End Date', (@procurement.mobilisation_end_date.strftime('%d/%m/%Y') if @procurement.mobilisation_period_required)]
  end

  def add_initial_call_off_period(sheet)
    sheet.add_row ['Initial Call-Off Period', initial_call_off_period]
    sheet.add_row ['Initial Call-Off Period Start Date', @procurement.initial_call_off_start_date.strftime('%d/%m/%Y')]
    sheet.add_row ['Initial Call-Off Period End Date', @procurement.initial_call_off_end_date.strftime('%d/%m/%Y')]
  end

  def add_extension_periods(sheet)
    4.times do |period|
      sheet.add_row ["Extension Period #{period + 1}", extension_period(period)]
    end
  end

  def extension_period(period)
    return nil if !@procurement.extensions_required || @procurement.call_off_extension(period).nil?

    "#{@procurement.extension_period_start_date(period).strftime('%d/%m/%Y')} - #{@procurement.extension_period_end_date(period).strftime('%d/%m/%Y')}"
  end

  def add_tupe(sheet)
    sheet.add_row []
    sheet.add_row ['TUPE involved', @procurement.tupe? ? 'Yes' : 'No']
  end

  ##### Methods shared between worksheets #####
  def add_header_row(sheet, initial_values)
    header_row_style = sheet.styles.add_style sz: 12, b: true, alignment: { wrap_text: true, horizontal: :center, vertical: :center }, border: { style: :thin, color: '00000000' }
    header_row = initial_values
    header_row += (1..@active_procurement_buildings.count).map { |x| "Building #{x}" }

    sheet.add_row header_row, style: header_row_style, height: standard_row_height
  end

  def add_building_name_row(sheet, initial_values, float)
    standard_style = sheet.styles.add_style sz: 12, border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center, horizontal: float }

    row = initial_values
    row += @active_procurement_buildings.map { |building| sanitize_string_for_excel(building.building_name) }

    sheet.add_row row, style: standard_style, height: standard_row_height
  end

  ##### Methods regarding the styling of the worksheets #####
  def standard_row_height
    35
  end

  def style_buildings_information_sheet(sheet, style)
    sheet['A1:A10'].each { |c| c.style = style }
    sheet.column_widths(*([50] * sheet.column_info.count))
  end

  def style_service_periods_matrix_sheet(sheet, style, hint_style, hint_center_style)
    column_widths = [15, 100]
    @active_procurement_buildings.count.times { column_widths << 50 }
    update_cell_styles(sheet, "D2:#{sheet.rows[2].cells.last.r}", hint_center_style)
    update_cell_styles(sheet, "A3:#{sheet.rows.last.cells.last.r}", hint_style)
    update_cell_styles(sheet, "A3:#{sheet.rows.last.cells[2].r}", style)
    sheet.column_widths(*column_widths)
  end

  def style_volume_sheet(sheet, style, number_volume_services)
    column_widths = [15, 100, 50, 50]
    @active_procurement_buildings.count.times { column_widths << 20 }

    last_column_name = ('A'..'ZZZ').to_a[2 + buildings_data.count]
    sheet["A2:#{last_column_name}#{number_volume_services + 2}"].each { |c| c.style = style } if number_volume_services.positive?
    sheet.column_widths(*column_widths)
  end

  def update_cell_styles(sheet, cells, style)
    sheet[cells].each { |cell| cell.style = style }
  end

  ##### Methods which help throughout the class #####
  ALLOWED_VOLUME_SERVICES = %w[C.5 E.4 G.1 G.3 G.5 H.4 H.5 I.1 I.2 I.3 I.4 J.1 J.2 J.3 J.4 J.5 J.6 K.1 K.2 K.3 K.4 K.5 K.6 K.7].freeze
  SERVICE_HOUR_SERVICES = %w[H.4 H.5 I.1 I.2 I.3 I.4 J.1 J.2 J.3 J.4 J.5 J.6].freeze

  def data_for_service_code(units, code)
    units.flatten.select { |measure| measure[:service_code] == code }
  end

  def find_service_for_building(data_for_service, building_id)
    data_for_service.find { |data| data[:building_id] == building_id }
  end

  def services_require_service_periods?
    return false if services_data.empty?

    services_data.pluck('code').uniq.intersect?(SERVICE_HOUR_SERVICES)
  end

  def volume_services_included?
    return false if services_data.empty?

    services_data.pluck('code').uniq.intersect?(ALLOWED_VOLUME_SERVICES)
  end

  def sanitize_string_for_excel(string)
    return unless string
    return "’#{string}" if string.match?(/\A(@|=|\+|-)/)

    string
  end
end
