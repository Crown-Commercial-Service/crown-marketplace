class FacilitiesManagement::DirectAwardSpreadsheet
  def initialize(contract_id)
    @contract = FacilitiesManagement::ProcurementSupplier.find(contract_id)
    @procurement = @contract.procurement

    @active_procurement_buildings = @procurement.active_procurement_buildings.order_by_building_name
    @supplier_name = @contract.supplier.data['supplier_name']

    frozen_rate_card = CCS::FM::FrozenRateCard.where(facilities_management_procurement_id: @procurement.id)
    @rate_card_data = frozen_rate_card.latest.data if frozen_rate_card.exists?
    @rate_card_data = CCS::FM::RateCard.latest.data unless frozen_rate_card.exists?

    set_data
    create_spreadsheet
  end

  def to_xlsx
    @package.to_stream.read
  end

  private

  def set_data
    @results = {}
    @report_results = {}

    # get the services including help & cafm for the,contract rate card,worksheet
    @report_results_no_cafmhelp_removed = {}
    @report = FacilitiesManagement::SummaryReport.new(@procurement.id)

    supplier_names = @report.selected_suppliers(@report.current_lot).map { |s| s['data']['supplier_name'] }

    supplier_names.each do |supplier_name|
      # e.g. dummy_supplier_name = 'Hickle-Schinner'
      @results[supplier_name] = {}
      @report.calculate_services_for_buildings supplier_name, true, :da, false
      @results[supplier_name] = @report.results

      @report_results_no_cafmhelp_removed[supplier_name] = {}
      @report.calculate_services_for_buildings supplier_name, false, :da, false
      @report_results_no_cafmhelp_removed[supplier_name] = @report.results
    end

    @data = @results[@supplier_name]

    @data_no_cafmhelp_removed = @report_results_no_cafmhelp_removed[@supplier_name]
    @uvals_contract = @active_procurement_buildings.map { |b| @report.uvals_for_building(b, :da)[0] }.flatten
  end

  def add_computed_row(sheet, sorted_building_keys, label, vals)
    standard_style = sheet.styles.add_style sz: 12, format_code: '£#,##0.00', border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center }

    new_row = []
    sum = 0
    sorted_building_keys.each do |k|
      new_row << vals[k]
      sum += vals[k]
    end
    new_row = ([label, nil, sum] << new_row).flatten
    sheet.add_row new_row, style: standard_style
  end

  # rubocop:disable Metrics/AbcSize
  def add_summation_row(sheet, sorted_building_keys, label, how_many_rows = 2, just_one = false)
    standard_style = sheet.styles.add_style sz: 12, format_code: '£#,##0.00', border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center }
    standard_column_style = sheet.styles.add_style sz: 12, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }
    new_row = [label, nil, nil]

    sorted_building_keys.each do |_k|
      new_row << '' if just_one == false
    end

    row_styles = [standard_column_style, standard_column_style, standard_style]
    sorted_building_keys.each { |_k| row_styles << standard_style } unless just_one

    sheet.add_row new_row, style: row_styles

    cell_refs = []
    (2..sheet.rows.last.cells.count - 1).each do |i|
      start = sheet.rows.last.cells[i].r_abs.index('$', 0)
      finish = sheet.rows.last.cells[i].r_abs.index('$', 1)

      column_ref = sheet.rows.last.cells[i].r_abs[start + 1..finish - 1]
      row_ref = sheet.rows.last.cells[i].r_abs[finish + 1..-1].to_i
      sheet.rows.last.cells[i].value = "=sum(#{column_ref}#{row_ref - 1}:#{column_ref}#{row_ref - how_many_rows})"

      cell_refs << sheet.rows.last.cells[i].r_abs

      break if just_one
    end
    cell_refs
  end
  # rubocop:enable Metrics/AbcSize

  def create_spreadsheet
    @package = Axlsx::Package.new
    @workbook = @package.workbook

    contract_price_matrix
    contract_rate_card
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/BlockLength
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def contract_rate_card
    all_units_of_measurement = CCS::FM::UnitsOfMeasurement.select(:id, :service_usage, :unit_measure_label)

    selected_building_names = []
    selected_building_info = []
    get_building_data(selected_building_names, selected_building_info)

    @workbook.add_worksheet(name: 'Contract Rate Card') do |sheet|
      header_row_style = sheet.styles.add_style sz: 12, b: true, alignment: { wrap_text: true, horizontal: :center, vertical: :center }, border: { style: :thin, color: '00000000' }
      price_style = sheet.styles.add_style sz: 12, format_code: '£#,##0.00', border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center }
      percentage_style = sheet.styles.add_style sz: 12, format_code: '#,##0.00 %', border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center }
      standard_column_style = sheet.styles.add_style sz: 12, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }
      bold_style = sheet.styles.add_style sz: 12, b: true

      sheet.add_row [@supplier_name], style: bold_style
      sheet.add_row ['Table 1. Service rates']

      new_row = ['Service Reference', 'Service Name', 'Unit of Measure']
      selected_building_names.each { |building_name| new_row << building_name }
      sheet.add_row new_row, style: header_row_style

      if @supplier_name
        rate_card_variances = @rate_card_data[:Variances][@supplier_name.to_sym]
        rate_card_prices = @rate_card_data[:Prices][@supplier_name.to_sym]
        @data_no_cafmhelp_removed.keys.collect { |k| @data_no_cafmhelp_removed[k].keys }
                                 .flatten.uniq
                                 .sort_by { |code| [code[0..code.index('.') - 1], code[code.index('.') + 1..-1].to_i] }.each do |s|
          new_row = []

          # for each building type, I need to see if the actual building name (which can contain several building id's if the same service
          # is contained in several building) has the service. for example two buildings may have the type warehouse and contain the same same C.1 service
          selected_building_names.each do |building_name|
            building_type_ids = selected_building_info.select { |building_info| building_info[:"building-type"] == building_name }
            building_linking_to_this_service = []
            building_type_ids.each do |building_type_id|
              contract_building_service = @uvals_contract.select { |uval| uval[:service_code] == s && uval[:building_id] == building_type_id[:building_id] }
              building_linking_to_this_service << contract_building_service unless contract_building_service.empty?
            end

            # only output the rate value for the cell if the service uval contains the building type otherwise output nil for the excel cell value
            is_building_containing_service = !building_linking_to_this_service.empty?
            row_value = nil unless is_building_containing_service
            row_value = @rate_card_data[:Prices][@supplier_name.to_sym][s.to_sym][building_name.to_sym] if is_building_containing_service
            new_row << row_value
          end

          unit_of_measurement_row = all_units_of_measurement.where("array_to_string(service_usage, '||') LIKE :code", code: '%' + s + '%').first
          unit_of_measurement_value = begin
                                        unit_of_measurement_row['unit_measure_label']
                                      rescue NameError
                                        nil
                                      end
          new_row = ([s, rate_card_prices[s.to_sym][:'Service Name'], unit_of_measurement_value] << new_row).flatten

          styles = [standard_column_style, standard_column_style, standard_column_style]

          CCS::FM::RateCard.building_types.count.times do
            styles << percentage_style if ['M.1', 'N.1'].include? s
            styles << price_style unless ['M.1', 'N.1'].include? s
          end

          sheet.add_row new_row, style: styles
        end

        sheet.add_row
        sheet.add_row
        sheet.add_row ['Table 2. Pricing Variables']
        sheet.add_row ['Cost type', 'Unit of Measure', 'Rate'], style: header_row_style

        sheet.add_row ['Cleaning Consumables', 'price per building occupant per annum', rate_card_variances[:'Cleaning Consumables per Building User (£)']], style: [standard_column_style, standard_column_style, price_style]
        sheet.add_row ['Management Overhead', 'percentage of deliverables value', rate_card_variances[:"Management Overhead %"]], style: [standard_column_style, standard_column_style, percentage_style]
        sheet.add_row ['Corporate Overhead', 'percentage of deliverables value', rate_card_variances[:"Corporate Overhead %"]], style: [standard_column_style, standard_column_style, percentage_style]
        sheet.add_row ['Profit', 'percentage of deliverables value', rate_card_variances[:'Profit %']], style: [standard_column_style, standard_column_style, percentage_style]
        sheet.add_row ['London Location Variance Rate', 'variance to standard service rate', rate_card_variances[:'London Location Variance Rate (%)']], style: [standard_column_style, standard_column_style, percentage_style]
        sheet.add_row ['TUPE Risk Premium', 'percentage of deliverables value', rate_card_variances[:'TUPE Risk Premium (DA %)']], style: [standard_column_style, standard_column_style, percentage_style]
        sheet.add_row ['Mobilisation Cost', 'percentage of deliverables value', rate_card_variances[:'Mobilisation Cost (DA %)']], style: [standard_column_style, standard_column_style, percentage_style]
      end
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/BlockLength
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  def get_building_data(selected_building_names, selected_building_info)
    selected_buildings_data = @active_procurement_buildings
    selected_buildings_data.each { |building_data| selected_building_names << building_data.building_type }
    selected_building_names.uniq!
    selected_buildings_data.each { |building_data| selected_building_info << { 'id': building_data.id, 'building-type': building_data.building_type, 'building_id': building_data.building_id } }
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/BlockLength
  # rubocop:disable Metrics/MethodLength
  def contract_price_matrix
    @workbook.add_worksheet(name: 'Contract Price Matrix') do |sheet|
      header_row_style = sheet.styles.add_style sz: 12, b: true, alignment: { wrap_text: true, horizontal: :center, vertical: :center }, border: { style: :thin, color: '00000000' }
      standard_column_style = sheet.styles.add_style sz: 12, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }
      standard_style = sheet.styles.add_style sz: 12, format_code: '£#,##0.00', border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center }
      total_style = sheet.styles.add_style sz: 12, format_code: '£#,##0.00', border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center }
      year_total_style = sheet.styles.add_style sz: 12, format_code: '£#,##0.00', border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center }
      variance_style = sheet.styles.add_style sz: 12, format_code: '£#,##0.00', border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center }

      sheet.add_row
      sheet.add_row ['Table 1. Baseline service costs for year 1']
      new_row = ['Service Reference', 'Service Name', 'Total']
      @active_procurement_buildings.each.with_index do |_k, idx|
        new_row << 'Building ' + (idx + 1).to_s
      end
      sheet.add_row new_row, style: header_row_style

      building_name_row = ['', '', '']
      @active_procurement_buildings.each { |building| building_name_row << sanitize_string_for_excel(building.building_name) }
      sheet.add_row building_name_row, style: header_row_style

      sorted_building_keys = @data.keys
      sumsum = 0
      sum_building = {}
      sum_building_cafm = {}
      sum_building_helpdesk = {}
      sum_building_variance = {}
      sum_building_tupe = {}
      sum_building_manage = {}
      sum_building_corporate = {}
      sum_building_profit = {}
      sum_building_mobilisation = {}
      sorted_building_keys.each do |k|
        sum_building[k] = 0
        sum_building_cafm[k] = 0
        sum_building_helpdesk[k] = 0
        sum_building_variance[k] = 0
        sum_building_tupe[k] = 0
        sum_building_manage[k] = 0
        sum_building_corporate[k] = 0
        sum_building_profit[k] = 0
        sum_building_mobilisation[k] = 0
      end

      @data.keys.collect { |k| @data[k].keys }
           .flatten.uniq
           .sort_by { |code| [code[0..code.index('.') - 1], code[code.index('.') + 1..-1].to_i] }.each do |s|
        new_row = [s, @rate_card_data[:Prices][@supplier_name.to_sym][s.to_sym][:'Service Name']]

        new_row2 = []
        sum = 0

        # this logic is to fix issue that the excel service prices were not aligned to the correct
        # building column, so insert nil into cell if no service data to align.

        sorted_building_keys.each do |k|
          new_row2 << nil if @data[k][s].nil?

          # If there's no service data for this service in this building, just move on

          next unless @data[k][s]

          new_row2 << @data[k][s][:subtotal1]
          sum += @data[k][s][:subtotal1]
          sum_building[k] += @data[k][s][:subtotal1]

          sum_building_cafm[k] += @data[k][s][:cafm]
          sum_building_helpdesk[k] += @data[k][s][:helpdesk]
          sum_building_variance[k] += @data[k][s][:variance]
          sum_building_tupe[k] += @data[k][s][:tupe]
          sum_building_manage[k] += @data[k][s][:manage]
          sum_building_corporate[k] += @data[k][s][:corporate]
          sum_building_profit[k] += @data[k][s][:profit]
          sum_building_mobilisation[k] += @data[k][s][:mobilisation]
        end

        sumsum += sum
        new_row = (new_row << sum << new_row2).flatten
        sheet.add_row new_row, style: standard_style
      end

      new_row = ['Planned Deliverables sub total', nil, sumsum]
      sorted_building_keys.each do |k|
        new_row << sum_building[k]
      end
      sheet.add_row new_row, style: standard_style

      sheet.add_row

      add_computed_row sheet, sorted_building_keys, 'CAFM', sum_building_cafm

      add_computed_row sheet, sorted_building_keys, 'Helpdesk', sum_building_helpdesk

      add_summation_row sheet, sorted_building_keys, 'Year 1 Deliverables sub total', 4
      sheet.add_row

      add_computed_row sheet, sorted_building_keys, 'London Location Variance', sum_building_variance

      add_summation_row sheet, sorted_building_keys, 'Year 1 Deliverables total', 3
      sheet.add_row

      add_computed_row sheet, sorted_building_keys, 'Mobilisation', sum_building_mobilisation

      add_computed_row sheet, sorted_building_keys, 'TUPE Risk Premium', sum_building_tupe

      add_summation_row sheet, sorted_building_keys, 'Total Charges excluding Overhead and Profit', 4
      sheet.add_row

      add_computed_row sheet, sorted_building_keys, 'Management Overhead', sum_building_manage

      add_computed_row sheet, sorted_building_keys, 'Corporate Overhead', sum_building_corporate

      add_summation_row sheet, sorted_building_keys, 'Total Charges excluding Profit', 4

      add_computed_row sheet, sorted_building_keys, 'Profit', sum_building_profit

      cell_refs = add_summation_row sheet, sorted_building_keys, 'Total Charges year 1', 2

      sheet.add_row
      sheet.add_row ['Table 2. Subsequent Years Total Charges']
      max_years =
        sorted_building_keys.collect { |k| @data[k].first[1][:contract_length_years] }.max

      if max_years > 1
        new_row = []
        sumsum = 0
        sorted_building_keys.each do |k|
          sum = @data[k].sum { |s| s[1][:subyearstotal] }
          new_row << sum
          sumsum += sum
        end

        (2..max_years).each do |i|
          new_row2 = ["Year #{i}", nil, sumsum]
          sheet.add_row new_row2, style: [standard_column_style, standard_column_style, standard_style]
        end
      end

      sheet.add_row
      add_summation_row sheet, sorted_building_keys, 'Total Charge (total contract cost)', max_years + 3, true
      sheet.add_row
      sheet.add_row ['Table 3. Total charges per month']
      new_row2 = ['Year 1 Monthly cost', nil, "= #{cell_refs.first} / 12"]
      sheet.add_row new_row2, style: [standard_column_style, standard_column_style, standard_style]

      if max_years > 1
        new_row = new_row.map { |x| x / 12 }
        (2..max_years).each do |i|
          new_row2 = ["Year #{i} Monthly cost", nil, sumsum / 12]
          sheet.add_row new_row2, style: [standard_column_style, standard_column_style, standard_style]
        end
      end

      sheet.add_row
      sheet.add_row ['NOTES']
      sheet.add_row ["For services 'CAFM' and 'Helpdesk' a £0 indicates this service is not required within this contract."]
      sheet.add_row ["For service 'Management of billable works' (if requested within this contract) pricing for works should be detailed as outlined within Call-off Schedule 4a Billable Works and Projects"]
      sheet.add_row ["For services 'Routine Cleaning' and 'Mobile Cleaning', the pricing within the service line includes both the service rate and the cleaning consumables."]

      service_count = @data.keys.collect { |k| @data[k].keys }.flatten.uniq.count
      # Service costs
      sheet["A#{service_count + 5}:C#{service_count + 5}"].each { |c| c.style = total_style }
      sheet["A4:B#{service_count + 5}"].each { |c| c.style = standard_column_style }
      sheet["A#{service_count + 7}:C#{service_count + 8}"].each { |c| c.style = variance_style }
      sheet["A#{service_count + 9}:C#{service_count + 9}"].each { |c| c.style = total_style }
      sheet["A#{service_count + 7}:B#{service_count + 9}"].each { |c| c.style = standard_column_style }
      sheet["A#{service_count + 11}:C#{service_count + 11}"].each { |c| c.style = variance_style }
      sheet["A#{service_count + 12}:C#{service_count + 12}"].each { |c| c.style = total_style }
      sheet["A#{service_count + 11}:B#{service_count + 12}"].each { |c| c.style = standard_column_style }
      sheet["A#{service_count + 14}:C#{service_count + 15}"].each { |c| c.style = variance_style }
      sheet["A#{service_count + 16}:C#{service_count + 16}"].each { |c| c.style = total_style }
      sheet["A#{service_count + 14}:B#{service_count + 16}"].each { |c| c.style = standard_column_style }
      # Year 1 charges
      sheet["A#{service_count + 18}:C#{service_count + 19}"].each { |c| c.style = variance_style }
      sheet["A#{service_count + 20}:C#{service_count + 20}"].each { |c| c.style = total_style }
      sheet["A#{service_count + 21}:C#{service_count + 21}"].each { |c| c.style = variance_style }
      sheet["A#{service_count + 22}:C#{service_count + 22}"].each { |c| c.style = year_total_style }
      sheet["A#{service_count + 18}:B#{service_count + 22}"].each { |c| c.style = standard_column_style }
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/BlockLength
  # rubocop:enable Metrics/AbcSize

  def sanitize_string_for_excel(string)
    return "'#{string}" if string.match?(/\A(@|=|\+|\-)/)

    string
  end
end
