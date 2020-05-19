class FacilitiesManagement::FurtherCompetitionSpreadsheetCreator < FacilitiesManagement::DeliverableMatrixSpreadsheetCreator
  attr_accessor :session_data

  def initialize(procurement_id)
    @procurement = FacilitiesManagement::Procurement.find(procurement_id)
    @report = FacilitiesManagement::SummaryReport.new(@procurement.id)
    @active_procurement_buildings = @procurement.active_procurement_buildings
  end

  def units_of_measure_values
    @units_of_measure_values ||= @active_procurement_buildings.map do |building|
      @report.fc_procurement_building_services(building).map do |procurement_building_service|
        {
          building_id: building.building_id,
          service_code: procurement_building_service.code,
          uom_value: procurement_building_service.uval,
          service_standard: procurement_building_service.service_standard,
          service_hours: procurement_building_service.service_hours
        }
      end
    end.flatten
  end

  def units_of_measure_values_for_volume
    @units_of_measure_values_for_volume ||= @active_procurement_buildings.map do |building|
      building.procurement_building_services.map do |procurement_building_service|
        {
          building_id: building.building_id,
          service_code: procurement_building_service.code,
          uom_value: procurement_building_service.uval,
          service_standard: procurement_building_service.service_standard,
          service_hours: procurement_building_service.service_hours
        }
      end
    end.flatten
  end

  def assessed_value
    return if @assessed_value

    @report.calculate_services_for_buildings
    @assessed_value = @report.assessed_value
  end

  # rubocop:disable Metrics/AbcSize
  def build
    start_date = @procurement.initial_call_off_start_date
    current_user = @procurement.user

    @package = Axlsx::Package.new do |p|
      p.workbook.styles do |s|
        first_column_style = s.add_style sz: 12, b: true, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }
        standard_column_style = s.add_style sz: 12, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }
        standard_bold_style = s.add_style sz: 12, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }, b: true

        p.workbook.add_worksheet(name: 'Buildings information') do |sheet|
          add_header_row(sheet, ['Buildings information'])
          add_buildings_information(sheet)
          style_buildings_information_sheet(sheet, first_column_style)
        end

        p.workbook.add_worksheet(name: 'Service Matrix') do |sheet|
          add_header_row(sheet, ['Service Reference', 'Service Name'])
          number_rows_added = add_service_matrix(sheet)
          style_service_matrix_sheet(sheet, standard_column_style, number_rows_added)
        end

        units_of_measure_values
        units_of_measure_values_for_volume
        unless @units_of_measure_values_for_volume.nil?
          p.workbook.add_worksheet(name: 'Volume') do |sheet|
            add_header_row(sheet, ['Service Reference',	'Service Name',	'Metric per annum'])
            number_volume_services = add_volumes_information_fc(sheet)
            style_volume_sheet(sheet, standard_column_style, number_volume_services)
          end
        end

        add_other_competition_worksheets(p, standard_column_style, standard_bold_style, start_date, current_user)
      end
    end
  end
  # rubocop:enable Metrics/AbcSize

  def add_volumes_information_fc(sheet)
    number_column_style = sheet.styles.add_style sz: 12, border: { style: :thin, color: '00000000' }

    allowed_volume_services = services_data.keep_if { |service| list_of_allowed_volume_services.include? service['code'] }

    allowed_volume_services.each do |s|
      new_row = [s['code'], s['name'], s['metric']]
      @active_procurement_buildings.each do |b|
        uvs = @units_of_measure_values_for_volume.flatten.select { |u| b.building_id == u[:building_id] }
        suv = uvs.find { |u| s['code'] == u[:service_code] }

        new_row << calculate_uom_value(suv) if suv
        new_row << nil unless suv
      end

      sheet.add_row new_row, style: number_column_style
    end

    allowed_volume_services.count
  end

  def add_other_competition_worksheets(package, standard_column_style, standard_bold_style, start_date, current_user)
    add_service_periods_worksheet(package, standard_column_style, @units_of_measure_values_for_volume)

    add_shortlist_details(package, standard_column_style, standard_bold_style, start_date, current_user)

    add_customer_and_contract_details(package) if @procurement
  end

  # rubocop:disable Metrics/AbcSize
  def add_service_matrix(sheet)
    rows_added = 0
    standard_style = sheet.styles.add_style sz: 12, border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center, horizontal: :center }

    services_data.each do |service|
      list_standards = get_sorted_list_unique_standards_per_building service
      list_standards.each do |standard|
        first_loop = true
        row_values = []
        buildings_data.each do |building|
          unit_of_measure = units_of_measure_values.find { |unit| unit[:building_id] == building[:building_id] && unit[:service_code] == service['code'] }
          service_name = determine_service_name(service['name'], unit_of_measure, standard)
          row_values << service['code'] << service_name if first_loop
          row_values << determine_service_matrix_cell_text(building, unit_of_measure, standard, service)
          first_loop = false
        end
        sheet.add_row row_values, style: standard_style, height: standard_row_height
        rows_added += 1
      end
    end
    rows_added
  end
  # rubocop:enable Metrics/AbcSize

  def determine_service_matrix_cell_text(building, unit_of_measure, standard, service)
    cell_text = ''
    cell_text = (building[:service_codes].include?(service['code']) ? 'Yes' : '') if standard.nil? || (building[:service_codes].include?(service['code']) && unit_of_measure[:service_standard] == standard)
    cell_text
  end

  def get_sorted_list_unique_standards_per_building(service)
    list_standards = Set[]
    buildings_data.each do |building|
      unit_of_measure = units_of_measure_values.find { |unit| unit[:building_id] == building[:building_id] && unit[:service_code] == service['code'] }
      list_standards.add(unit_of_measure[:service_standard]) if unit_of_measure && unit_of_measure[:service_standard]
    end
    list_standards.add nil if list_standards.empty?
    list_standards.sort
  end

  def style_service_matrix_sheet(sheet, style, number_rows_added)
    column_widths = [15, 100]
    buildings_data.count.times { column_widths << 50 }

    last_column_name = ('A'..'ZZ').to_a[1 + buildings_data.count]
    sheet["A2:#{last_column_name}#{number_rows_added + 1}"].each { |c| c.style = style } if number_rows_added.positive?

    sheet.column_widths(*column_widths)
  end

  def determine_service_name(name, unit_of_measure, standard_name)
    return name + ' - Standard ' + standard_name if unit_of_measure && unit_of_measure[:service_standard]

    name
  end

  def add_shortlist_details(package, standard_column_style, standard_bold_style, start_date, current_user)
    package.workbook.add_worksheet(name: 'Shortlist') do |sheet|
      add_shortlist_contract_number(sheet, standard_column_style)
      add_shortlist_cost_sublot_recommendation(sheet, start_date, current_user, standard_column_style, standard_bold_style)
      sheet.add_row [], style: standard_column_style, height: standard_row_height

      add_shortlist_supplier_names(sheet)

      style_shortlist_sheet(sheet)
    end
  end

  def add_shortlist_contract_number(sheet, style)
    sheet.add_row ["#{@procurement.contract_number} - #{@procurement.contract_datetime}"], style: style, height: standard_row_height
    sheet.add_row [], style: style, height: standard_row_height
  end

  def add_shortlist_cost_sublot_recommendation(sheet, _start_date, _current_user, standard_style, bold_style)
    sheet.add_row ['Cost and sub-lot recommendation'], style: bold_style, height: standard_row_height
    sheet.add_row ['Estimated cost', ActionController::Base.helpers.number_to_currency(assessed_value, unit: '£', precision: 2) + ' ', partial_estimated_text], style: standard_style, height: standard_row_height
    sheet.add_row ['Sub-lot recommendation', 'Sub-lot ' + @report.current_lot, sublot_customer_selected_text], style: standard_style, height: standard_row_height
    sheet.add_row ['Sub-lot value range', determine_lot_range], style: standard_style, height: standard_row_height
  end

  def  sublot_customer_selected_text
    if (@procurement.any_services_missing_framework_price? || @procurement.any_services_missing_benchmark_price?) && !@procurement.estimated_cost_known?
      '(Customer selected)'
    else
      ''
    end
  end

  def partial_estimated_text
    if some_services_without_price_outside_variance?
      '(Estimated cost not calculated)'
    elsif @procurement.all_services_missing_framework_price?
      estimation_text_for_all_services_missing
    elsif (@procurement.any_services_missing_framework_price? || @procurement.any_services_missing_benchmark_price?) && !@procurement.estimated_cost_known?
      '(Partial estimated cost)'
    else
      ''
    end
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

  def add_customer_and_contract_details(package)
    package.workbook.add_worksheet(name: 'Customer & Contract Details') do |sheet|
      add_customer_details(sheet)
      add_contract_requirements(sheet)
    end
  end

  def add_customer_details(sheet)
    bold_style = sheet.styles.add_style b: true
    telephone_number_style = sheet.styles.add_style format_code: '0##########', alignment: { horizontal: :left }
    buyer_detail = @procurement.user.buyer_detail

    sheet.add_row ['1. Customer details'], style: bold_style
    sheet.add_row ['Contract Name', @procurement.contract_name]
    sheet.add_row ['Buyer Organisation Name', buyer_detail.organisation_name]
    sheet.add_row ['Buyer Organisation Address', get_address(buyer_detail)]
    sheet.add_row ['Buyer Organisation Sector', buyer_detail.central_government? ? 'Central Government' : 'Wider Public Sector']
    sheet.add_row ['Buyer Contact Name', buyer_detail.full_name]
    sheet.add_row ['Buyer Contact Job Title', buyer_detail.job_title]
    sheet.add_row ['Buyer Contact Email Address', @procurement.user.email]
    sheet.add_row ['Buyer Contact Telephone Number', buyer_detail.telephone_number], style: [nil, telephone_number_style]
  end

  def get_address(buyer_detail)
    str_array = [buyer_detail.organisation_address_line_1,
                 buyer_detail.organisation_address_line_2,
                 buyer_detail.organisation_address_town,
                 buyer_detail.organisation_address_county]
    str_array.reject(&:blank?).join(', ') + '. ' + buyer_detail.organisation_address_postcode
  end

  def determine_lot_range
    lot_range = 'UNKNOWN'
    case @report.current_lot
    when '1a'
      lot_range = 'Up to £7m'
    when '1b'
      lot_range = 'between £7m-50m'
    when '1c'
      lot_range = 'over £50m'
    end
    lot_range
  end

  def add_shortlist_supplier_names(sheet)
    standard_style = sheet.styles.add_style sz: 12, border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center, horizontal: :left }, fg_color: '6E6E6E'
    bold_style = sheet.styles.add_style sz: 12, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }, b: true

    label = 'Suppliers shortlist'
    supplier_names = @report.selected_suppliers(@report.current_lot).map { |s| s['data']['supplier_name'] }
    supplier_names.each do |supplier_name|
      sheet.add_row [label, supplier_name], style: standard_style, height: standard_row_height
      label = nil
    end

    sheet['A8:A8'].each { |c| c.style = bold_style } unless supplier_names.empty?
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

  def list_of_allowed_volume_services
    %w[C.5 E.4 G.1 G.3 G.5 H.4 H.5 I.1 I.2 I.3 I.4 J.1 J.2 J.3 J.4 J.5 J.6 K.1 K.2 K.3 K.4 K.5 K.6 K.7]
  end
end
