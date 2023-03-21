module FacilitiesManagement::RM3830
  class PriceMatrixSpreadsheet
    def initialize(contract_id)
      @contract = ProcurementSupplier.find(contract_id)
      @procurement = @contract.procurement
      @active_procurement_buildings = @procurement.active_procurement_buildings.order_by_building_name
      @supplier_id = @contract.supplier_id.to_sym
      @supplier_name = @contract.supplier.supplier_name
      frozen_rate_card = FrozenRateCard.where(facilities_management_rm3830_procurement_id: @procurement.id)
      @rate_card_data = frozen_rate_card.latest.data if frozen_rate_card.exists?
      @rate_card_data = RateCard.latest.data unless frozen_rate_card.exists?
    end

    def build
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
      @report = SummaryReport.new(@procurement.id)

      @report.calculate_services_for_buildings @supplier_id, :da, true
      ids = @active_procurement_buildings.joins(:building).pluck('facilities_management_buildings.id')
      @data = @report.results.sort_by { |id, _| ids.index(id) }.to_h

      @report.calculate_services_for_buildings @supplier_id, :da, false
      @data_no_cafmhelp_removed = @report.results.sort_by { |id, _| ids.index(id) }.to_h
    end

    def add_computed_row(sheet, sorted_building_keys, label, vals)
      standard_style = sheet.styles.add_style sz: 12, format_code: '£#,##0.00', border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center }

      sum = 0
      new_row = sorted_building_keys.map do |k|
        sum += vals[k]
        vals[k]
      end
      new_row = [label, nil, sum] + new_row
      sheet.add_row new_row, style: standard_style
    end

    # rubocop:disable Metrics/AbcSize
    def add_summation_row(sheet, sorted_building_keys, label, how_many_rows = 2, just_one = false)
      standard_style = sheet.styles.add_style sz: 12, format_code: '£#,##0.00', border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center }
      standard_column_style = sheet.styles.add_style sz: 12, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }
      new_row = [label, nil, nil]
      row_styles = [standard_column_style, standard_column_style, standard_style]

      unless just_one
        new_row += [''] * sorted_building_keys.count
        row_styles += [standard_style] * sorted_building_keys.count
      end

      sheet.add_row new_row, style: row_styles

      cell_refs = []
      (2..sheet.rows.last.cells.count - 1).each do |i|
        start = sheet.rows.last.cells[i].r_abs.index('$', 0)
        finish = sheet.rows.last.cells[i].r_abs.index('$', 1)

        column_ref = sheet.rows.last.cells[i].r_abs[start + 1..finish - 1]
        row_ref = sheet.rows.last.cells[i].r_abs[finish + 1..].to_i
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

    def contract_rate_card
      assign_service_codes_for_each_building_type

      @workbook.add_worksheet(name: 'Contract Rate Card') do |sheet|
        header_row_style = sheet.styles.add_style sz: 12, b: true, alignment: { wrap_text: true, horizontal: :center, vertical: :center }, border: { style: :thin, color: '00000000' }
        bold_style = sheet.styles.add_style sz: 12, b: true

        sheet.add_row [@supplier_name], style: bold_style
        sheet.add_row ['Table 1. Service rates']

        new_row = ['Service Reference', 'Service Name', 'Unit of Measure']
        new_row += @building_types_with_service_codes.pluck(:building_type)
        sheet.add_row new_row, style: header_row_style

        add_supplier_rates_to_rate_card(sheet) if @supplier_name
      end
    end

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def add_supplier_rates_to_rate_card(sheet)
      all_units_of_measurement = UnitsOfMeasurement.all
      standard_column_style = sheet.styles.add_style sz: 12, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }
      price_style = sheet.styles.add_style sz: 12, format_code: '£#,##0.00', border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center }
      percentage_style = sheet.styles.add_style sz: 12, format_code: '#,##0.00 %', border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center }

      rate_card_prices = @rate_card_data[:Prices][@supplier_id]

      @data_no_cafmhelp_removed.keys.collect { |k| @data_no_cafmhelp_removed[k].keys }
                               .flatten.uniq
                               .sort_by { |code| [code[0..code.index('.') - 1], code[code.index('.') + 1..].to_i] }.each do |s|
        # for each building type, I need to see if the actual building name (which can contain several building id's if the same service
        # is contained in several building) has the service. for example two buildings may have the type warehouse and contain the same same C.1 service

        new_row = @building_types_with_service_codes.map do |building_type_with_service_codes|
          @rate_card_data[:Prices][@supplier_id][s.to_sym][building_type_with_service_codes[:building_type].to_sym] if building_type_with_service_codes[:service_codes].include? s
        end

        unit_of_measurement_row = all_units_of_measurement.where("array_to_string(service_usage, '||') LIKE :code", code: "%#{s}%").first
        unit_of_measurement_value = begin
          unit_of_measurement_row['unit_measure_label']
        rescue NameError
          nil
        end
        new_row = ([s, rate_card_prices[s.to_sym][:'Service Name'], unit_of_measurement_value] << new_row).flatten

        styles = [standard_column_style, standard_column_style, standard_column_style]

        styles += RateCard.building_types.count.times.map do
          if ['M.1', 'N.1'].include? s
            percentage_style
          else
            price_style
          end
        end

        sheet.add_row new_row, style: styles
      end

      add_table_headings_for_pricing_variables(sheet)
      add_pricing_variables_to_rate_card_sheet(sheet)
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    def add_pricing_variables_to_rate_card_sheet(sheet)
      rate_card_variances = @rate_card_data[:Variances][@supplier_id]
      standard_column_style = sheet.styles.add_style sz: 12, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }
      price_style = sheet.styles.add_style sz: 12, format_code: '£#,##0.00', border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center }
      percentage_style = sheet.styles.add_style sz: 12, format_code: '#,##0.00 %', border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center }

      sheet.add_row ['Cleaning Consumables', 'price per building occupant per annum', rate_card_variances[:'Cleaning Consumables per Building User (£)']], style: [standard_column_style, standard_column_style, price_style]
      sheet.add_row ['Management Overhead', 'percentage of deliverables value', rate_card_variances[:'Management Overhead %']], style: [standard_column_style, standard_column_style, percentage_style]
      sheet.add_row ['Corporate Overhead', 'percentage of deliverables value', rate_card_variances[:'Corporate Overhead %']], style: [standard_column_style, standard_column_style, percentage_style]
      sheet.add_row ['Profit', 'percentage of deliverables value', rate_card_variances[:'Profit %']], style: [standard_column_style, standard_column_style, percentage_style]
      sheet.add_row ['London Location Variance Rate', 'variance to standard service rate', rate_card_variances[:'London Location Variance Rate (%)']], style: [standard_column_style, standard_column_style, percentage_style]
      sheet.add_row ['TUPE Risk Premium', 'percentage of deliverables value', rate_card_variances[:'TUPE Risk Premium (DA %)']], style: [standard_column_style, standard_column_style, percentage_style]
      sheet.add_row ['Mobilisation Cost', 'percentage of deliverables value', rate_card_variances[:'Mobilisation Cost (DA %)']], style: [standard_column_style, standard_column_style, percentage_style]
    end

    def add_table_headings_for_pricing_variables(sheet)
      header_row_style = sheet.styles.add_style sz: 12, b: true, alignment: { wrap_text: true, horizontal: :center, vertical: :center }, border: { style: :thin, color: '00000000' }

      sheet.add_row
      sheet.add_row
      sheet.add_row ['Table 2. Pricing Variables']
      sheet.add_row ['Cost type', 'Unit of Measure', 'Rate'], style: header_row_style
    end

    def assign_service_codes_for_each_building_type
      selected_building_types = @active_procurement_buildings.pluck(:building_type).uniq
      @building_types_with_service_codes = selected_building_types.map do |building_type|
        service_codes = @active_procurement_buildings.select { |apb| apb.building_type == building_type }.pluck(:service_codes).flatten.uniq
        { building_type: building_type, service_codes: service_codes }
      end
    end

    # rubocop:disable Metrics/MethodLength, Metrics/BlockLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def contract_price_matrix
      @workbook.add_worksheet(name: 'Contract Price Matrix') do |sheet|
        header_row_style = sheet.styles.add_style sz: 12, b: true, alignment: { wrap_text: true, horizontal: :center, vertical: :center }, border: { style: :thin, color: '00000000' }
        standard_column_style = sheet.styles.add_style sz: 12, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }
        standard_style = sheet.styles.add_style sz: 12, format_code: '£#,##0.00', border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center }
        total_style = sheet.styles.add_style sz: 12, format_code: '£#,##0.00', border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center }
        year_total_style = sheet.styles.add_style sz: 12, format_code: '£#,##0.00', border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center }
        variance_style = sheet.styles.add_style sz: 12, format_code: '£#,##0.00', border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center }
        table_count = 0

        sheet.add_row
        sheet.add_row ["Table #{table_count += 1}. Baseline service costs for year 1"]

        new_row = ['Service Reference', 'Service Name', 'Total']
        new_row += (1..@active_procurement_buildings.count).map { |index| "Building #{index}" }

        sheet.add_row new_row, style: header_row_style

        building_name_row = ['', '', '']
        building_name_row += @active_procurement_buildings.map { |building| sanitize_string_for_excel(building.building_name) }
        sheet.add_row building_name_row, style: header_row_style

        sorted_building_keys = @data.keys
        sumsum = 0
        sum_building = {}
        sum_building_cafm = {}
        sum_building_helpdesk = {}
        sum_building_london_variance = {}
        sum_building_tupe = {}
        sum_building_manage = {}
        sum_building_corporate = {}
        sum_building_profit = {}
        sum_building_mobilisation = {}
        sorted_building_keys.each do |k|
          sum_building[k] = 0
          sum_building_cafm[k] = 0
          sum_building_helpdesk[k] = 0
          sum_building_london_variance[k] = 0
          sum_building_tupe[k] = 0
          sum_building_manage[k] = 0
          sum_building_corporate[k] = 0
          sum_building_profit[k] = 0
          sum_building_mobilisation[k] = 0
        end

        @data.keys.collect { |k| @data[k].keys }
             .flatten.uniq
             .sort_by { |code| [code[0..code.index('.') - 1], code[code.index('.') + 1..].to_i] }.each do |s|
          new_row = [s, @rate_card_data[:Prices][@supplier_id][s.to_sym][:'Service Name']]

          sum = 0

          # this logic is to fix issue that the excel service prices were not aligned to the correct
          # building column, so insert nil into cell if no service data to align.

          new_row2 = sorted_building_keys.map do |k|
            service_data = @data[k][s]
            if service_data.nil?
              nil
            else
              sum += service_data[:subtotal1]
              sum_building[k] += service_data[:subtotal1]

              sum_building_cafm[k] += service_data[:cafm]
              sum_building_helpdesk[k] += service_data[:helpdesk]
              sum_building_london_variance[k] += service_data[:london_variance]
              sum_building_tupe[k] += service_data[:tupe_risk_premium]
              sum_building_manage[k] += service_data[:management_overhead]
              sum_building_corporate[k] += service_data[:corporate_overhead]
              sum_building_profit[k] += service_data[:profit]
              sum_building_mobilisation[k] += service_data[:mobilisation]

              service_data[:subtotal1]
            end
          end

          sumsum += sum
          new_row += [sum] + new_row2
          sheet.add_row new_row, style: standard_style
        end

        new_row = ['Planned Deliverables sub total', nil, sumsum]
        new_row += sorted_building_keys.map { |k| sum_building[k] }

        sheet.add_row new_row, style: standard_style

        sheet.add_row

        add_computed_row sheet, sorted_building_keys, 'CAFM', sum_building_cafm

        add_computed_row sheet, sorted_building_keys, 'Helpdesk', sum_building_helpdesk

        add_summation_row sheet, sorted_building_keys, 'Year 1 Deliverables sub total', 4
        sheet.add_row

        add_computed_row sheet, sorted_building_keys, 'London Location Variance', sum_building_london_variance

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

        contract_length_years = @data[sorted_building_keys.first].first[1][:contract_length_years]

        subsiquent_years_length = (contract_length_years - 1).clamp(0, 10)
        max_years = contract_length_years.ceil

        if max_years > 1
          sheet.add_row
          sheet.add_row ["Table #{table_count += 1}. Subsequent Years Total Charges"]

          yearly_charge = sorted_building_keys.sum do |key|
            @data[key].sum { |s| s[1][:subsequent_yearly_charge] }
          end

          (2..max_years).each do |i|
            year_length = [(subsiquent_years_length + 2 - i).clamp(0, 10), 1.0].min

            new_row = ["Year #{i}", nil, yearly_charge * year_length]
            sheet.add_row new_row, style: [standard_column_style, standard_column_style, standard_style]
          end
        end

        summation_rows_count = if max_years > 1
                                 max_years + 3
                               else
                                 max_years + 1
                               end

        sheet.add_row
        add_summation_row sheet, sorted_building_keys, 'Total Charge (total contract cost)', summation_rows_count, true
        sheet.add_row
        sheet.add_row ["Table #{table_count + 1}. Total charges per month"]

        if max_years > 1
          new_row = ['Year 1 Monthly cost', nil, "= #{cell_refs.first} / 12"]
          sheet.add_row new_row, style: [standard_column_style, standard_column_style, standard_style]

          (2..max_years).each do |i|
            new_row = ["Year #{i} Monthly cost", nil, yearly_charge / 12.0]
            sheet.add_row new_row, style: [standard_column_style, standard_column_style, standard_style]
          end
        else
          new_row = ['Year 1 Monthly cost', nil, "= #{cell_refs.first} / #{(12 * contract_length_years).round}"]
          sheet.add_row new_row, style: [standard_column_style, standard_column_style, standard_style]
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
    # rubocop:enable Metrics/MethodLength, Metrics/BlockLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    def sanitize_string_for_excel(string)
      return "'#{string}" if string.match?(/\A(@|=|\+|-)/)

      string
    end
  end
end
