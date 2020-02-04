require 'axlsx'
require 'axlsx_rails'
require 'roo'

class FacilitiesManagement::DeliverableMatrixSpreadsheetCreator
  include FacilitiesManagement::Beta::SummaryHelper
  include ActionView::Helpers::SanitizeHelper

  def initialize(building_ids_with_service_codes, units_of_measure_values = nil, procurement_id = nil)
    @building_ids_with_service_codes = building_ids_with_service_codes
    building_ids = building_ids_with_service_codes.map { |h| h[:building_id] }
    @buildings = FacilitiesManagement::Buildings.where(id: building_ids)
    @procurement = FacilitiesManagement::Procurement.find(procurement_id) unless procurement_id.nil?
    buildings_with_service_codes
    set_services
    @units_of_measure_values = units_of_measure_values
  end

  def to_xlsx
    @package.to_stream.read
  end

  def build
    @package = Axlsx::Package.new do |p|
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

        add_customer_and_contract_details(p) if @procurement

        add_service_details_sheet(p)
      end
    end
  end

  private

  def add_customer_and_contract_details(package)
    package.workbook.add_worksheet(name: 'Customer & Contract Details') do |sheet|
      add_contract_number(sheet)
      add_customer_details(sheet)
      add_contract_requirements(sheet)
    end
  end

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
    standard_style = sheet.styles.add_style sz: 12, border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center }

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
    standard_style = sheet.styles.add_style sz: 12, border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center, horizontal: :center }

    @services.each do |service|
      row_values = [service['code'], service['name']]

      @building_ids_with_service_codes.each do |building|
        v = building[:service_codes].include?(service['code']) ? 'Yes' : ''
        row_values << v
      end

      sheet.add_row row_values, style: standard_style, height: standard_row_height
    end
  end

  # rubocop:disable Metrics/AbcSize
  def add_volumes_information(sheet)
    all_units_of_measurement = CCS::FM::UnitsOfMeasurement.select(:id, :service_usage, :unit_measure_label)

    number_column_style = sheet.styles.add_style sz: 12, border: { style: :thin, color: '00000000' }

    services_without_help_cafm = remove_help_cafm_services(@services)
    services_without_help_cafm.each do |s|
      unit_of_measurement_row = all_units_of_measurement.where("array_to_string(service_usage, '||') LIKE :code", code: '%' + s['code'] + '%').first
      unit_of_measurement_value = begin
                                    unit_of_measurement_row['unit_measure_label']
                                  rescue NameError
                                    nil
                                  end
      new_row = [s['code'], s['name'], s['metric'], unit_of_measurement_value]
      @buildings_with_service_codes.each do |b|
        uvs = @units_of_measure_values.select { |u| b[:building][:id] == u[:building_id] }

        suv = uvs.find { |u| s['code'] == u[:service_code] }

        new_row << calculate_uom_value(suv) if suv
        new_row << nil unless suv
      end

      sheet.add_row new_row, style: number_column_style
    end
  end
  # rubocop:enable Metrics/AbcSize

  def style_volume_sheet(sheet, style)
    column_widths = [15, 100, 50, 50]
    @buildings.count.times { column_widths << 20 }
    sheet["A2:D#{remove_help_cafm_services(@services).count + 1}"].each { |c| c.style = style }
    sheet.column_widths(*column_widths)
  end

  def remove_help_cafm_services(services)
    services.reject { |x| x['code'] == 'M.1' || x['code'] == 'N.1' }
  end

  def add_contract_number(sheet)
    time = Time.now.getlocal
    contract_number = FacilitiesManagement::ContractNumberGenerator.new(procurement_state: :direct_award, used_numbers: []).new_number
    sheet.add_row ["#{contract_number} - #{time.strftime('%Y/%m/%d')} - #{time.strftime('%l:%M%P')}"]
    sheet.add_row []
  end

  def add_customer_details(sheet)
    bold_style = sheet.styles.add_style b: true
    telephone_number_style = sheet.styles.add_style format_code: '0##########', alignment: { horizontal: :left }
    buyer_detail = @procurement.user.buyer_detail

    sheet.add_row ['1. Customer details'], style: bold_style
    sheet.add_row ['Contract name', @procurement.contract_name]
    sheet.add_row ['Buyer Organisation Name', buyer_detail.organisation_name]
    sheet.add_row ['Buyer Organisation Sector', buyer_detail.central_government? ? 'Central Government' : 'Wider Public Sector']
    sheet.add_row ['Buyer Contact Name', buyer_detail.full_name]
    sheet.add_row ['Buyer Contact Job Title', buyer_detail.job_title]
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
    sheet.add_row ['Mobilisation Period', ("#{@procurement.mobilisation_period} weeks" unless @procurement.mobilisation_period.nil?)]
    sheet.add_row ['Mobilisation Start Date', ((@procurement.initial_call_off_start_date - @procurement.mobilisation_period.weeks - 1.day).strftime('%d/%m/%Y') unless @procurement.mobilisation_period.nil?)]
    sheet.add_row ['Mobilisation End Date', ((@procurement.initial_call_off_start_date - 1.day).strftime('%d/%m/%Y') unless @procurement.mobilisation_period.nil?)]
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
    return nil if @procurement.try("optional_call_off_extensions_#{period}").nil?

    @procurement.try("extension_period_#{period}_start_date").strftime('%d/%m/%Y') + ' - ' + @procurement.try("extension_period_#{period}_end_date").strftime('%d/%m/%Y')
  end

  def add_tupe(sheet)
    sheet.add_row []
    sheet.add_row ['TUPE involved', @procurement.tupe? ? 'Yes' : 'No']
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
      832, 838, 845, 859, 874, 895, 898, 920,
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
      1857, 1872, 1885, 1893, 1901, 1908, 1915,
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
      630, 653, 669, 677, 727, 753, 771, 782, 795, 809,
      815, 823, 831, 837, 844, 858, 873, 950, 958, 965,
      992, 1009, 1035, 1052, 1066, 1083, 1092, 1118,
      1127, 1131, 1136, 1181, 1189, 1203, 1209, 1215,
      1231, 1242, 1247, 1253, 1267, 1284, 1253, 1267, 1284,
      1304, 1311, 1317, 1328, 1339, 1352, 1363, 1370,
      1382, 1415, 1420, 1437, 1444, 1450, 1465, 1488,
      1493, 1499, 1514, 1521, 1530, 1543, 1558, 1565, 1590,
      1604, 1611, 1618, 1628, 1639, 1666, 1673, 1678,
      1728, 1751, 1775, 1785, 1801, 1807, 1814, 1822,
      1832, 1841, 1871, 1884, 1892, 1900, 1907, 1914,
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
end
