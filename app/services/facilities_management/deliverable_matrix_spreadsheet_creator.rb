require 'caxlsx'
require 'caxlsx_rails'
require 'roo'

class FacilitiesManagement::DeliverableMatrixSpreadsheetCreator
  include ActionView::Helpers::SanitizeHelper

  def initialize(contract_id)
    @contract = FacilitiesManagement::ProcurementSupplier.find(contract_id)
    @procurement = @contract.procurement
    @active_procurement_buildings = @procurement.active_procurement_buildings.order_by_building_name
  end

  def buildings_data
    @buildings_data ||= @active_procurement_buildings.map { |b| { building_id: b.building_id, service_codes: b.service_codes } }
  end

  # rubocop:disable Metrics/AbcSize
  def services_data
    uniq_buildings_service_codes ||= buildings_data.map { |pb| pb[:service_codes] }.flatten.uniq
    services ||= FacilitiesManagement::StaticData.work_packages.select { |wp| uniq_buildings_service_codes.include? wp['code'] }
    @services_data ||= services.sort { |a, b| [a['code'].split('.')[0], a['code'].split('.')[1].to_i] <=> [b['code'].split('.')[0], b['code'].split('.')[1].to_i] }
  end
  # rubocop:enable Metrics/AbcSize

  def units_of_measure_values
    @units_of_measure_values ||= @active_procurement_buildings.map do |building|
      da_procurement_building_services(building).map do |procurement_building_service|
        {
          building_id: building.building_id,
          service_code: procurement_building_service.code,
          uom_value: procurement_building_service.uval,
          service_standard: procurement_building_service.service_standard,
          detail_of_requirement: procurement_building_service.detail_of_requirement
        }
      end
    end
  end

  def to_xlsx
    @package.to_stream.read
  end

  def build
    @package = Axlsx::Package.new do |p|
      p.workbook.styles do |s|
        first_column_style = s.add_style sz: 12, b: true, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }
        standard_column_style = s.add_style sz: 12, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }

        add_buildings_worksheet(p, first_column_style)

        add_service_matrix_worksheet(p, standard_column_style)

        add_volume_worksheet(p, standard_column_style) if volume_services_included?

        add_service_periods_worksheet(p, standard_column_style, units_of_measure_values) if services_require_service_periods?

        add_customer_and_contract_details(p) if @procurement

        add_service_details_sheet(p)
      end
    end
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

  ##### Methods regarding the building of the 'Service Matrix' worksheet #####
  def add_service_matrix_worksheet(package, standard_column_style)
    package.workbook.add_worksheet(name: 'Service Matrix') do |sheet|
      add_header_row(sheet, ['Service Reference', 'Service Name'])
      add_building_name_row(sheet, ['', ''], :center)
      add_service_matrix(sheet)
      style_service_matrix_sheet(sheet, standard_column_style)
    end
  end

  def add_service_matrix(sheet)
    standard_style = sheet.styles.add_style sz: 12, border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center, horizontal: :center }

    services_data.each do |service|
      row_values = [service['code'], service['name']]
      row_values += @active_procurement_buildings.map { |building| building.service_codes.include?(service['code']) ? 'Yes' : '' }

      sheet.add_row row_values, style: standard_style, height: standard_row_height
    end
  end

  ##### Methods regarding the building of the 'Volume' worksheet #####
  def add_volume_worksheet(package, standard_column_style)
    package.workbook.add_worksheet(name: 'Volume') do |sheet|
      add_header_row(sheet, ['Service Reference', 'Service Name', 'Metric per annum'])
      add_building_name_row(sheet, ['', '', ''], :center)
      number_volume_services = add_volumes_information_da(sheet)
      style_volume_sheet(sheet, standard_column_style, number_volume_services)
    end
  end

  def add_volumes_information_da(sheet)
    number_column_style = sheet.styles.add_style sz: 12, border: { style: :thin, color: '00000000' }

    added_rows = 0
    allowed_volume_services = services_data.keep_if { |service| ALLOWED_VOLUME_SERVICES.include? service['code'] }

    allowed_volume_services.each do |service|
      next if CCS::FM::Service.gia_services.include? service['code']

      data_for_service = data_for_service_code(units_of_measure_values, service['code'])
      new_row = [service['code'], service['name'], service['metric']]
      new_row += service_measure_information(data_for_service)

      added_rows += 1
      sheet.add_row new_row, style: number_column_style
    end

    added_rows
  end

  def service_measure_information(data_for_service)
    @active_procurement_buildings.map do |building|
      service_measure = find_service_for_building(data_for_service, building.building_id)

      if service_measure.nil?
        nil
      else
        service_measure[:uom_value].to_f
      end
    end
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
    FacilitiesManagement::StaticData.work_packages.select { |work_package| allowed_services << work_package['code'] if work_package['metric'] == 'Number of hours required' }
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
  def add_customer_and_contract_details(package)
    package.workbook.add_worksheet(name: 'Customer & Contract Details') do |sheet|
      add_contract_number(sheet) if @contract.contract_number.present?
      add_customer_details(sheet)
      add_contract_requirements(sheet)
    end
  end

  def add_contract_number(sheet)
    sheet.add_row ['Reference number:', @contract.contract_number.to_s]
    sheet.add_row ['Date/time of production of this document:', @contract.offer_sent_date&.in_time_zone('London')&.strftime('%Y/%m/%d - %l:%M%P')]
    sheet.add_row []
  end

  def add_customer_details(sheet)
    bold_style = sheet.styles.add_style b: true

    sheet.add_row ['1. Customer details'], style: bold_style
    add_sanitized_customer_details(sheet)
  end

  def add_sanitized_customer_details(sheet)
    telephone_number_style = sheet.styles.add_style format_code: '0##########', alignment: { horizontal: :left }
    buyer_detail = @procurement.user.buyer_detail
    sheet.add_row ['Contract name', sanitize_string_for_excel(@procurement.contract_name)]
    sheet.add_row ['Buyer Organisation Name', sanitize_string_for_excel(buyer_detail.organisation_name)]
    sheet.add_row ['Buyer Organisation Sector', buyer_detail.central_government? ? 'Central Government' : 'Wider Public Sector']
    sheet.add_row ['Buyer Contact Name', sanitize_string_for_excel(buyer_detail.full_name)]
    sheet.add_row ['Buyer Contact Job Title', sanitize_string_for_excel(buyer_detail.job_title)]
    sheet.add_row ['Buyer Contact Email Address', @procurement.user.email]
    sheet.add_row ['Buyer Contact Telephone Number', buyer_detail.telephone_number], style: [nil, telephone_number_style]
  end

  def add_contract_requirements(sheet)
    bold_style = sheet.styles.add_style b: true
    sheet.add_row []
    sheet.add_row ['2. Contract requirements'], style: bold_style
    add_initial_call_off_period(sheet)
    add_mobilisation_period(sheet)
    sheet.add_row ['Date of First Indexation', (@procurement.initial_call_off_start_date + 1.year).strftime('%d/%m/%Y')]
    add_extension_periods(sheet)
    add_tupe(sheet)
  end

  def add_mobilisation_period(sheet)
    sheet.add_row ['Mobilisation Period', ("#{@procurement.mobilisation_period} weeks" if @procurement.mobilisation_period_required)]
    sheet.add_row ['Mobilisation Start Date', ((@procurement.initial_call_off_start_date - @procurement.mobilisation_period.weeks - 1.day).strftime('%d/%m/%Y') if @procurement.mobilisation_period_required)]
    sheet.add_row ['Mobilisation End Date', ((@procurement.initial_call_off_start_date - 1.day).strftime('%d/%m/%Y') if @procurement.mobilisation_period_required)]
  end

  def add_initial_call_off_period(sheet)
    sheet.add_row ['Initial Call-Off Period', "#{@procurement.initial_call_off_period} years"]
    sheet.add_row ['Initial Call-Off Period Start Date', @procurement.initial_call_off_start_date.strftime('%d/%m/%Y')]
    sheet.add_row ['Initial Call-Off Period End Date', (@procurement.initial_call_off_start_date + @procurement.initial_call_off_period.years - 1.day).strftime('%d/%m/%Y')]
  end

  def add_extension_periods(sheet)
    (1..4).each do |period|
      sheet.add_row ["Extension Period #{period}", extension_period(period)]
    end
  end

  def extension_period(period)
    return nil if !@procurement.extensions_required || @procurement.try("optional_call_off_extensions_#{period}").nil?

    @procurement.try("extension_period_#{period}_start_date").strftime('%d/%m/%Y') + ' - ' + @procurement.try("extension_period_#{period}_end_date").strftime('%d/%m/%Y')
  end

  def add_tupe(sheet)
    sheet.add_row []
    sheet.add_row ['TUPE involved', @procurement.tupe? ? 'Yes' : 'No']
  end

  ##### Methods regarding the building of the 'Service Descriptions' worksheet #####
  def add_service_details_sheet(package)
    service_descriptions_sheet = Roo::Spreadsheet.open(Rails.root.join('app', 'assets', 'files', 'FMServiceDescriptions.xlsx'), extension: :xlsx)
    service_descriptions = service_descriptions_sheet.sheet('Service Descriptions')

    package.workbook.add_worksheet(name: 'Service Information') do |sheet|
      (service_descriptions.first_row..service_descriptions.last_row).each do |row_number|
        sanitized_row = service_descriptions.row(row_number).map { |cell| strip_tags(cell) }
        sheet.add_row sanitized_row, widths: [nil, 20, 200]
      end

      apply_service_information_sheet_styling(sheet)
    end
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

  def style_service_matrix_sheet(sheet, style)
    column_widths = [15, 100]
    @active_procurement_buildings.count.times { column_widths << 50 }
    sheet["A3:B#{services_data.count + 2}"].each { |c| c.style = style }
    sheet.column_widths(*column_widths)
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

  def apply_service_information_sheet_styling(sheet)
    header_row_style = sheet.styles.add_style sz: 12, b: true, alignment: { wrap_text: true, horizontal: :center, vertical: :center }, border: { style: :thin, color: '00000000' }, bg_color: 'D2D9EF'
    no_style = sheet.styles.add_style bg_color: 'FFFFFF', b: false, fg_color: 'FFFFFF'
    standard_style = sheet.styles.add_style sz: 12, alignment: { wrap_text: true }, border: { style: :thin, color: 'F000000' }

    sheet['A1:C2266'].each { |c| c.style = standard_style }
    sheet['A1:C1'].each { |c| c.style = header_row_style }
    bold_rows(sheet)
    bold_red_rows(sheet)
    grey_rows(sheet)
    workpackage_header_rows(sheet)

    sheet['A1:A2266'].each { |c| c.style = no_style }
    sheet.column_info.first.hidden = true
  end

  def bold_rows(sheet)
    bold_style = sheet.styles.add_style sz: 12, b: true, border: { style: :thin, color: 'F000000' }

    bolded_rows.each do |row|
      sheet["A#{row}:C#{row}"].each { |c| c.style = bold_style }
    end
  end

  def bold_red_rows(sheet)
    bold_red_style = sheet.styles.add_style sz: 12, b: true, fg_color: 'B00004', border: { style: :thin, color: 'F000000' }

    bolded_red_rows.each do |row|
      sheet["A#{row}:C#{row}"].each { |c| c.style = bold_red_style }
    end
  end

  def grey_rows(sheet)
    grey_style = sheet.styles.add_style bg_color: '807E7E'

    greyed_rows.each do |row|
      sheet["A#{row}:C#{row}"].each { |c| c.style = grey_style }
    end
  end

  def workpackage_header_rows(sheet)
    wp_header_style = sheet.styles.add_style sz: 12, b: true, bg_color: 'FFFFFF'

    bolded_no_border_rows.each do |row|
      sheet["A#{row}:C#{row}"].each { |c| c.style = wp_header_style }
    end
  end

  def bolded_rows
    [
      4, 26, 42, 64, 96, 101, 112, 123, 128, 143,
      162, 176, 179, 184, 187, 210, 215, 230, 236,
      247, 260, 269, 295, 308, 312, 314, 333, 342,
      350, 369, 383, 390, 396, 399, 402, 412, 415,
      422, 424, 429, 432, 436, 442, 444, 455, 462,
      477, 479, 492, 497, 511, 523, 548, 555,
      563, 596, 613, 621, 631, 654, 670, 678,
      728, 754, 767, 772, 783, 796, 810, 816, 824,
      832, 838, 845, 850, 859, 874, 895, 898, 920,
      951, 959, 966, 993, 1010, 1027, 1036,
      1053, 1067, 1084, 1093, 1119, 1128, 1132, 1137,
      1152, 1182, 1190, 1204, 1210, 1216, 1232,
      1243, 1248, 1254, 1268, 1271, 1275, 1285, 1305,
      1312, 1318, 1329, 1340, 1353, 1364, 1371, 1383,
      1416, 1421, 1438, 1445, 1451, 1466, 1481,
      1489, 1494, 1500, 1515, 1522, 1531, 1544, 1559,
      1566, 1591, 1605, 1612, 1619, 1629, 1640,
      1657, 1667, 1674, 1679, 1687, 1729, 1752,
      1776, 1786, 1802, 1808, 1815, 1823, 1833, 1842,
      1847, 1857, 1872, 1885, 1893, 1901, 1908, 1915,
      1924, 1940, 1957, 1971, 1978, 1985, 1990,
      1994, 1999, 2004, 2032, 2101, 2207, 2260, 2262
    ]
  end

  def bolded_red_rows
    [
      5, 27, 43, 65, 97, 102, 113, 124, 129, 144,
      237, 248, 261, 270, 296, 309, 313, 463, 493
    ]
  end

  def greyed_rows
    [
      25, 41, 63, 95, 100, 111, 122, 127, 142, 235,
      246, 259, 268, 294, 307, 311, 461, 595, 612, 620,
      630, 653, 669, 677, 727, 753, 766, 771, 782, 795, 809,
      815, 823, 831, 837, 844, 849, 858, 873, 950, 958, 965,
      992, 1009, 1035, 1052, 1066, 1083, 1092, 1118,
      1127, 1131, 1136, 1181, 1189, 1203, 1209, 1215,
      1231, 1242, 1247, 1253, 1267, 1284, 1253, 1267, 1284,
      1304, 1311, 1317, 1328, 1339, 1352, 1363, 1370,
      1382, 1415, 1420, 1437, 1444, 1450, 1465, 1488,
      1493, 1499, 1514, 1521, 1530, 1543, 1558, 1565, 1590,
      1604, 1611, 1618, 1628, 1639, 1666, 1673, 1678,
      1728, 1751, 1753, 1775, 1785, 1801, 1807, 1814, 1822,
      1832, 1841, 1846, 1871, 1884, 1892, 1900, 1907, 1914,
      1939, 1956, 1970, 1977, 1984, 1989, 1993, 1998,
      2003, 2031
    ]
  end

  def bolded_no_border_rows
    [
      2, 3, 489, 490, 491, 560, 561, 562, 892, 893, 894,
      1024, 1025, 1026, 1149, 1150, 1151, 1272, 1273, 1274,
      1478, 1479, 1480, 1654, 1655, 1656, 1684, 1685, 1686,
      1854, 1855, 1856, 1921, 1922, 1923, 1923, 2098, 2099,
      2100, 2204, 2205, 2206, 2259, 2260, 2261
    ]
  end

  def update_cell_styles(sheet, cells, style)
    sheet[cells].each { |cell| cell.style = style }
  end

  ##### Methods which help throughout the class #####
  ALLOWED_VOLUME_SERVICES = %w[C.5 E.4 G.1 G.3 G.5 H.4 H.5 I.1 I.2 I.3 I.4 J.1 J.2 J.3 J.4 J.5 J.6 K.1 K.2 K.3 K.4 K.5 K.6 K.7].freeze
  SERVICE_HOUR_SERVICES = %w[H.4 H.5 I.1 I.2 I.3 I.4 J.1 J.2 J.3 J.4 J.5 J.6].freeze

  def da_procurement_building_services(building)
    procurement_building_service_codes = CCS::FM::Service.direct_award_services(@procurement.id)

    building.procurement_building_services.select { |u| u.code.in? procurement_building_service_codes }
  end

  def data_for_service_code(units, code)
    units.flatten.select { |measure| measure[:service_code] == code }
  end

  def find_service_for_building(data_for_service, building_id)
    data_for_service.find { |data| data[:building_id] == building_id }
  end

  def services_require_service_periods?
    return false if services_data.empty?

    (services_data.map { |sd| sd['code'] }.uniq & SERVICE_HOUR_SERVICES).size.positive?
  end

  def volume_services_included?
    return false if services_data.empty?

    (services_data.map { |sd| sd['code'] }.uniq & ALLOWED_VOLUME_SERVICES).size.positive?
  end

  def sanitize_string_for_excel(string)
    return unless string
    return "’#{string}" if string.match?(/\A(@|=|\+|\-)/)

    string
  end
end
