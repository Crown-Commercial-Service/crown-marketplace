module FacilitiesManagement::RM3830
  class DirectAwardDeliverablesMatrix < DeliverableMatrixSpreadsheetCreator
    include ActionView::Helpers::SanitizeHelper
    include ActionView::Helpers::TextHelper
    include FacilitiesManagement::ContractDatesHelper

    def initialize(contract_id)
      @contract = ProcurementSupplier.find(contract_id)
      @procurement = @contract.procurement
      @active_procurement_buildings = @procurement.active_procurement_buildings.order_by_building_name
    end

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
        next if Service.gia_services.include? service['code']

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

    ##### Methods regarding the styling of the worksheets #####

    def style_service_matrix_sheet(sheet, style)
      column_widths = [15, 100]
      @active_procurement_buildings.count.times { column_widths << 50 }
      sheet["A3:B#{services_data.count + 2}"].each { |c| c.style = style }
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

    ##### Methods which help throughout the class #####
    def da_procurement_building_services(building)
      procurement_building_service_codes = Service.direct_award_services(@procurement.id)

      building.procurement_building_services.select { |u| u.code.in? procurement_building_service_codes }
    end
  end
end
