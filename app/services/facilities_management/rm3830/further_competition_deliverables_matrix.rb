module FacilitiesManagement::RM3830
  class FurtherCompetitionDeliverablesMatrix < DeliverableMatrixSpreadsheetCreator
    attr_accessor :session_data

    def initialize(procurement_id)
      @procurement = Procurement.find(procurement_id)
      @report = SummaryReport.new(@procurement.id)
      @active_procurement_buildings = @procurement.active_procurement_buildings.order_by_building_name
    end

    def units_of_measure_values
      @units_of_measure_values ||= @active_procurement_buildings.map do |building|
        building.procurement_building_services.map do |procurement_building_service|
          {
            building_id: building.building_id,
            service_code: procurement_building_service.code,
            uom_value: procurement_building_service.uval,
            service_standard: procurement_building_service.service_standard,
            detail_of_requirement: procurement_building_service.detail_of_requirement
          }
        end
      end.flatten
    end

    def build
      @package = Axlsx::Package.new do |p|
        p.workbook.styles do |s|
          first_column_style = s.add_style sz: 12, b: true, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }
          standard_column_style = s.add_style sz: 12, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }
          standard_bold_style = s.add_style sz: 12, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }, b: true

          add_buildings_worksheet(p, first_column_style)

          add_service_matrix_worksheet(p, standard_column_style)

          add_volume_worksheet(p, standard_column_style) if volume_services_included?

          add_service_periods_worksheet(p, standard_column_style, units_of_measure_values) if services_require_service_periods?

          add_shortlist_details(p, standard_column_style, standard_bold_style)

          add_customer_and_contract_details(p) if @procurement
        end
      end
    end

    private

    ##### Methods regarding the building of the 'Service Matrix' worksheet #####
    def add_service_matrix_worksheet(package, standard_column_style)
      package.workbook.add_worksheet(name: 'Service Matrix') do |sheet|
        add_header_row(sheet, ['Service Reference', 'Service Name'])
        add_building_name_row(sheet, ['', ''], :center)
        number_rows_added = add_service_matrix(sheet)
        style_service_matrix_sheet(sheet, standard_column_style, number_rows_added)
      end
    end

    def add_service_matrix(sheet)
      rows_added = 0
      standard_style = sheet.styles.add_style sz: 12, border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center, horizontal: :center }

      services_data.each do |service|
        data_for_service = data_for_service_code(units_of_measure_values, service['code'])
        list_standards = get_sorted_list_unique_standards_per_building data_for_service

        list_standards.each do |standard|
          service_name = determine_service_name(service['name'], standard)
          row_values = [service['code'], service_name]

          row_values += buildings_data.map do |building|
            unit_of_measure = find_service_for_building(data_for_service, building[:building_id])
            determine_service_matrix_cell_text(unit_of_measure, standard)
          end
          sheet.add_row row_values, style: standard_style, height: standard_row_height
          rows_added += 1
        end
      end
      rows_added
    end

    def get_sorted_list_unique_standards_per_building(data_for_service)
      list_standards = data_for_service.pluck(:service_standard).compact.uniq.sort
      list_standards << nil if list_standards.empty?
      list_standards.sort
    end

    def determine_service_matrix_cell_text(unit_of_measure, standard)
      if unit_of_measure.present? && unit_of_measure[:service_standard] == standard
        'Yes'
      else
        ''
      end
    end

    ##### Methods regarding the building of the 'Volume' worksheet #####
    def add_volume_worksheet(package, standard_column_style)
      package.workbook.add_worksheet(name: 'Volume') do |sheet|
        add_header_row(sheet, ['Service Reference',	'Service Name',	'Metric per annum'])
        add_building_name_row(sheet, ['', '', ''], :center)
        number_volume_services = add_volumes_information_fc(sheet)
        style_volume_sheet(sheet, standard_column_style, number_volume_services)
      end
    end

    def add_volumes_information_fc(sheet)
      number_column_style = sheet.styles.add_style sz: 12, border: { style: :thin, color: '00000000' }
      allowed_volume_services = services_data.keep_if { |service| ALLOWED_VOLUME_SERVICES.include? service['code'] }

      allowed_volume_services.each do |service|
        new_row = [service['code'], service['name'], service['metric']]
        data_for_service = data_for_service_code(units_of_measure_values, service['code'])

        new_row += @active_procurement_buildings.map do |building|
          service_measure = find_service_for_building(data_for_service, building.building_id)

          service_measure[:uom_value].to_f unless service_measure.nil?
        end

        sheet.add_row new_row, style: number_column_style
      end

      allowed_volume_services.count
    end

    ##### Methods regarding the building of the 'Shortlist' worksheet #####
    def add_shortlist_details(package, standard_column_style, _standard_bold_style)
      package.workbook.add_worksheet(name: 'Shortlist') do |sheet|
        standard_style = sheet.styles.add_style sz: 12, alignment: { horizontal: :left, vertical: :center }
        bold_style = sheet.styles.add_style sz: 12, alignment: { horizontal: :left, vertical: :center }, b: true
        hint_style = sheet.styles.add_style sz: 12, alignment: { wrap_text: true, vertical: :center, horizontal: :left }, fg_color: '6E6E6E'
        link_style = sheet.styles.add_style sz: 12, alignment: { vertical: :center, horizontal: :left }, fg_color: '4472c4', u: true

        add_shortlist_contract_number(sheet, bold_style, hint_style)
        add_shortlist_cost_sublot_recommendation(sheet, standard_style, bold_style, hint_style)
        sheet.add_row [], style: standard_column_style, height: standard_row_height

        add_shortlist_supplier_names(sheet, standard_style, bold_style, hint_style, link_style)

        style_shortlist_sheet(sheet)
      end
    end

    def add_shortlist_contract_number(sheet, bold_style, hint_style)
      sheet.add_row ['Reference number:', @procurement.contract_number], style: bold_style, height: standard_row_height
      sheet.add_row ['Date/time production of this document:', @procurement.contract_datetime], style: bold_style, height: standard_row_height
      sheet.add_row [], style: bold_style, height: standard_row_height
      update_cell_styles(sheet, 'B1:B2', hint_style)
    end

    def add_shortlist_cost_sublot_recommendation(sheet, standard_style, bold_style, hint_style)
      sheet.add_row ['Cost and sub-lot recommendation'], style: bold_style, height: standard_row_height
      sheet.add_row ['Estimated cost', "#{ActionController::Base.helpers.number_to_currency(@procurement.assessed_value, unit: '£', precision: 2)} ", partial_estimated_text], style: hint_style, height: standard_row_height
      sheet.add_row ['Sub-lot recommendation', "Sub-lot #{@procurement.lot_number}", sublot_customer_selected_text], style: hint_style, height: standard_row_height
      sheet.add_row ['Sub-lot value range', determine_lot_range], style: hint_style, height: standard_row_height
      update_cell_styles(sheet, 'A5:A7', standard_style)
    end

    def add_shortlist_supplier_names(sheet, standard_style, bold_style, hint_style, link_style)
      suppliers = @procurement.procurement_suppliers.map(&:supplier).sort_by(&:supplier_name)

      return if suppliers.empty?

      sheet.add_row ['Suppliers shortlist', 'Further supplier information and contact details can be found here:'], style: bold_style, height: standard_row_height
      update_cell_styles(sheet, 'B9:B9', standard_style)

      suppliers.each do |supplier|
        sheet.add_row [supplier.supplier_name], style: hint_style, height: standard_row_height
      end

      sheet.rows[9].add_cell 'https://www.crowncommercial.gov.uk/agreements/RM3830/suppliers', style: link_style
      sheet.add_hyperlink location: 'https://www.crowncommercial.gov.uk/agreements/RM3830/suppliers', ref: sheet['B10']
    end

    def  sublot_customer_selected_text
      if (@procurement.any_services_missing_framework_price? || @procurement.any_services_missing_benchmark_price?) && !@procurement.estimated_cost_known?
        '(Customer selected)'
      else
        ''
      end
    end

    def partial_estimated_text
      if estimated_cost_not_calculated?
        '(Estimated cost not calculated)'
      elsif @procurement.all_services_missing_framework_and_benchmark_price?
        estimation_text_for_all_services_missing
      elsif (@procurement.any_services_missing_framework_price? || @procurement.any_services_missing_benchmark_price?) && !@procurement.estimated_cost_known?
        '(Partial estimated cost)'
      else
        ''
      end
    end

    def estimated_cost_not_calculated?
      some_services_without_price_outside_variance? || @procurement.assessed_value < 0.005
    end

    def some_services_without_price_outside_variance?
      # variance is NOT within -30% and +30%
      @procurement.estimated_cost_known? && !@procurement.all_services_missing_framework_price? && @report.values_to_average.size < 2
    end

    def estimation_text_for_all_services_missing
      if @procurement.estimated_cost_known?
        '(Estimated cost not calculated)'
      else
        ''
      end
    end

    def determine_lot_range
      case @procurement.lot_number
      when '1a'
        'Up to £7m'
      when '1b'
        'between £7m-50m'
      when '1c'
        'over £50m'
      else
        'UNKNOWN'
      end
    end

    ##### Methods regarding the building of the 'Customer & Contract Details' worksheet #####
    def add_customer_and_contract_details(package)
      package.workbook.add_worksheet(name: 'Customer & Contract Details') do |sheet|
        add_customer_details(sheet)
        add_contract_requirements(sheet)
      end
    end

    def add_customer_details(sheet)
      bold_style = sheet.styles.add_style b: true

      sheet.add_row ['1. Customer details'], style: bold_style
      sheet.add_row ['Contract Name', sanitize_string_for_excel(@procurement.contract_name)]
      add_sanitized_customer_details(sheet)
    end

    def add_sanitized_customer_details(sheet)
      telephone_number_style = sheet.styles.add_style format_code: '0##########', alignment: { horizontal: :left }
      buyer_detail = @procurement.user.buyer_detail
      sheet.add_row ['Buyer Organisation Name', sanitize_string_for_excel(buyer_detail.organisation_name)]
      sheet.add_row ['Buyer Organisation Address', get_address(buyer_detail)]
      sheet.add_row ['Buyer Organisation Sector', buyer_detail.central_government? ? 'Central Government' : 'Wider Public Sector']
      sheet.add_row ['Buyer Contact Name', sanitize_string_for_excel(buyer_detail.full_name)]
      sheet.add_row ['Buyer Contact Job Title', sanitize_string_for_excel(buyer_detail.job_title)]
      sheet.add_row ['Buyer Contact Email Address', @procurement.user.email]
      sheet.add_row ['Buyer Contact Telephone Number', buyer_detail.telephone_number], style: [nil, telephone_number_style]
    end

    def get_address(buyer_detail)
      str_array = [sanitize_string_for_excel(buyer_detail.organisation_address_line_1),
                   sanitize_string_for_excel(buyer_detail.organisation_address_line_2),
                   sanitize_string_for_excel(buyer_detail.organisation_address_town),
                   sanitize_string_for_excel(buyer_detail.organisation_address_county)]
      "#{str_array.compact_blank.join(', ')}. #{sanitize_string_for_excel(buyer_detail.organisation_address_postcode)}"
    end

    ##### Methods regarding the styling of the worksheets #####
    def style_service_matrix_sheet(sheet, style, number_rows_added)
      column_widths = [15, 100]
      buildings_data.count.times { column_widths << 50 }

      last_column_name = ('A'..'ZZZ').to_a[1 + buildings_data.count]
      sheet["A3:#{last_column_name}#{number_rows_added + 2}"].each { |c| c.style = style } if number_rows_added.positive?

      sheet.column_widths(*column_widths)
    end

    def determine_service_name(name, standard_name)
      return "#{name} - Standard #{standard_name}" if standard_name

      name
    end

    def style_supplier_names_sheet(sheet, style, rows_added)
      column_widths = [75, 50]
      sheet["A2:B#{rows_added + 1}"].each { |c| c.style = style } if rows_added.positive?
      sheet.column_widths(*column_widths)
    end

    def style_shortlist_sheet(sheet)
      column_widths = [50, 50, 50]
      sheet.column_widths(*column_widths)
    end
  end
end
