class FacilitiesManagement::DirectAwardSpreadsheet
  def initialize(supplier_name, data, rate_card)
    @supplier_name = supplier_name
    @data = data
    @rate_card_data = rate_card.data.deep_symbolize_keys
    create_spreadsheet
  end

  def to_xlsx
    @package.to_stream.read
  end

  private

  def add_computed_row(sheet, sorted_building_keys, label, vals)
    standard_style = sheet.styles.add_style sz: 12, format_code: '£#,###.00', border: { style: :thin, color: '00000000' }, bg_color: 'FCFF40', alignment: { wrap_text: true, vertical: :center }

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
    standard_style = sheet.styles.add_style sz: 12, format_code: '£#.00', border: { style: :thin, color: '00000000' }, bg_color: 'FCFF40', alignment: { wrap_text: true, vertical: :center }
    standard_column_style = sheet.styles.add_style sz: 12, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }
    new_row = [label, nil, nil]

    sorted_building_keys.each do |_k|
      new_row << '' if just_one == false
    end

    row_styles = [standard_column_style, standard_column_style, standard_style]
    sorted_building_keys.each { |_k| row_styles << standard_style } unless just_one

    sheet.add_row new_row, style: row_styles

    (2..sheet.rows.last.cells.count - 1).each do |i|
      start = sheet.rows.last.cells[i].r_abs.index('$', 0)
      finish = sheet.rows.last.cells[i].r_abs.index('$', 1)

      column_ref = sheet.rows.last.cells[i].r_abs[start + 1..finish - 1]
      row_ref = sheet.rows.last.cells[i].r_abs[finish + 1..-1].to_i
      sheet.rows.last.cells[i].value = "=sum(#{column_ref}#{row_ref - 1}:#{column_ref}#{row_ref - how_many_rows})"

      break if just_one
    end
  end
  # rubocop:enable Metrics/AbcSize

  def create_spreadsheet
    @package = Axlsx::Package.new
    @workbook = @package.workbook

    contract_price_matrix
    contract_rate_card
  end

  # rubocop:disable Metrics/AbcSize
  def contract_rate_card
    @workbook.add_worksheet(name: 'Contract Rate Card') do |sheet|
      header_row_style = sheet.styles.add_style sz: 12, b: true, alignment: { wrap_text: true, horizontal: :center, vertical: :center }, border: { style: :thin, color: '00000000' }
      price_style = sheet.styles.add_style sz: 12, format_code: '£#,##0.00', border: { style: :thin, color: '00000000' }, bg_color: 'FCFF40', alignment: { wrap_text: true, vertical: :center }
      percentage_style = sheet.styles.add_style sz: 12, format_code: '#.00 %', border: { style: :thin, color: '00000000' }, bg_color: 'FCFF40', alignment: { wrap_text: true, vertical: :center }
      standard_column_style = sheet.styles.add_style sz: 12, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }

      sheet.add_row [@supplier_name]
      sheet.add_row ['Table 1. Service rates']

      new_row = ['Service Reference', 'Service Name', 'Unit of Measure']
      CCS::FM::RateCard.building_types.each { |b| new_row << b }
      sheet.add_row new_row, style: header_row_style

      if @supplier_name
        rate_card_variances = @rate_card_data[:Variances][@supplier_name.to_sym]
        rate_card_prices = @rate_card_data[:Prices][@supplier_name.to_sym]

        @data.keys.collect { |k| @data[k].keys }
             .flatten.uniq
             .sort_by { |code| [code[0..code.index('.') - 1], code[code.index('.') + 1..-1].to_i] }.each do |s|
          labels = @data.keys.sort.collect { |k| @data[k][s][:spreadsheet_label] }

          new_row = []
          CCS::FM::RateCard.building_types.each { |b| new_row << @rate_card_data[:Prices][@supplier_name.to_sym][s.to_sym][b] }

          new_row = ([s, rate_card_prices[s.to_sym][:'Service Name'], labels.first] << new_row).flatten

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

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/BlockLength
  # rubocop:disable Metrics/MethodLength
  def contract_price_matrix
    @workbook.add_worksheet(name: 'Contract Price Matrix') do |sheet|
      header_row_style = sheet.styles.add_style sz: 12, b: true, alignment: { wrap_text: true, horizontal: :center, vertical: :center }, border: { style: :thin, color: '00000000' }
      standard_column_style = sheet.styles.add_style sz: 12, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }
      standard_style = sheet.styles.add_style sz: 12, format_code: '£#.00', border: { style: :thin, color: '00000000' }, bg_color: 'FCFF40', alignment: { wrap_text: true, vertical: :center }
      total_style = sheet.styles.add_style sz: 12, format_code: '£#.00', border: { style: :thin, color: '00000000' }, bg_color: '70AD47', alignment: { wrap_text: true, vertical: :center }
      year_total_style = sheet.styles.add_style sz: 12, format_code: '£#.00', border: { style: :thin, color: '00000000' }, bg_color: 'ED7D31', alignment: { wrap_text: true, vertical: :center }
      variance_style = sheet.styles.add_style sz: 12, format_code: '£#.00', border: { style: :thin, color: '00000000' }, bg_color: 'BDD6EE', alignment: { wrap_text: true, vertical: :center }

      sheet.add_row
      sheet.add_row ['Table 1. Baseline service costs for year 1']
      new_row = ['Service Reference', 'Service Name', 'Total']
      @data.keys.sort.each.with_index do |_k, idx|
        new_row << 'Building ' + (idx + 1).to_s
      end
      sheet.add_row new_row, style: header_row_style

      sorted_building_keys = @data.keys.sort
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

        sorted_building_keys.each do |k|
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

      add_summation_row sheet, sorted_building_keys, 'Total Charges year 1', 2

      sheet.add_row
      sheet.add_row ['Table 2. Subsequent Years Total Charges']
      max_years =
        sorted_building_keys.collect { |k| @data[k].first[1][:subsequent_length_years] }.max

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

      sheet.add_row
      add_summation_row sheet, sorted_building_keys, 'Total Charge (total contract cost)', max_years + 3, true
      sheet.add_row
      sheet.add_row ['Table 3. Total charges per month']
      new_row = new_row.map { |x| x / 12 }
      (1..max_years).each do |i|
        new_row2 = ["Year #{i} Monthly cost", nil, sumsum / 12]
        sheet.add_row new_row2, style: [standard_column_style, standard_column_style, standard_style]
      end

      service_count = @data.keys.collect { |k| @data[k].keys }.flatten.uniq.count
      # Service costs
      sheet["A#{service_count + 4}:C#{service_count + 4}"].each { |c| c.style = total_style }
      sheet["A4:B#{service_count + 4}"].each { |c| c.style = standard_column_style }
      sheet["A#{service_count + 6}:C#{service_count + 7}"].each { |c| c.style = variance_style }
      sheet["A#{service_count + 8}:C#{service_count + 8}"].each { |c| c.style = total_style }
      sheet["A#{service_count + 6}:B#{service_count + 8}"].each { |c| c.style = standard_column_style }
      sheet["A#{service_count + 10}:C#{service_count + 10}"].each { |c| c.style = variance_style }
      sheet["A#{service_count + 11}:C#{service_count + 11}"].each { |c| c.style = total_style }
      sheet["A#{service_count + 10}:B#{service_count + 11}"].each { |c| c.style = standard_column_style }
      sheet["A#{service_count + 13}:C#{service_count + 14}"].each { |c| c.style = variance_style }
      sheet["A#{service_count + 15}:C#{service_count + 15}"].each { |c| c.style = total_style }
      sheet["A#{service_count + 13}:B#{service_count + 15}"].each { |c| c.style = standard_column_style }
      # Year 1 charges
      sheet["A#{service_count + 17}:C#{service_count + 18}"].each { |c| c.style = variance_style }
      sheet["A#{service_count + 19}:C#{service_count + 19}"].each { |c| c.style = total_style }
      sheet["A#{service_count + 20}:C#{service_count + 20}"].each { |c| c.style = variance_style }
      sheet["A#{service_count + 21}:C#{service_count + 21}"].each { |c| c.style = year_total_style }
      sheet["A#{service_count + 17}:B#{service_count + 21}"].each { |c| c.style = standard_column_style }
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/BlockLength
  # rubocop:enable Metrics/AbcSize
end
