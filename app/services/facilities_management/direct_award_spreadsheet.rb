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
    new_row = []
    sum = 0
    sorted_building_keys.each do |k|
      new_row << vals[k]
      sum += vals[k]
    end
    new_row = ([label, nil, sum] << new_row).flatten
    sheet.add_row new_row
  end

  # rubocop:disable Metrics/AbcSize
  def add_summation_row(sheet, sorted_building_keys, label, how_many_rows = 2)
    new_row = [label, nil, nil]
    sorted_building_keys.each do |_k|
      new_row << ''
    end
    sheet.add_row new_row
    (2..sheet.rows.last.cells.count - 1).each do |i|
      start = sheet.rows.last.cells[i].r_abs.index('$', 0)
      finish = sheet.rows.last.cells[i].r_abs.index('$', 1)

      column_ref = sheet.rows.last.cells[i].r_abs[start + 1..finish - 1]
      row_ref = sheet.rows.last.cells[i].r_abs[finish + 1..-1].to_i
      sheet.rows.last.cells[i].value = "=sum(#{column_ref}#{row_ref - 1}:#{column_ref}#{row_ref - how_many_rows})"
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
      sheet.add_row [@supplier_name]
      sheet.add_row ['Table 1. Service rates']

      new_row = ['Service Reference', 'Service Name', 'Unit of Measure']
      CCS::FM::RateCard.building_types.each do |b|
        new_row << b
      end
      sheet.add_row new_row

      if @supplier_name
        rate_card_discounts = @rate_card_data[:Discounts][@supplier_name.to_sym]
        rate_card_variances = @rate_card_data[:Variances][@supplier_name.to_sym]
        rate_card_prices = @rate_card_data[:Prices][@supplier_name.to_sym]

        @data.keys.collect { |k| @data[k].keys }
             .flatten.uniq
             .sort_by { |code| [code[0..code.index('.') - 1], code[code.index('.') + 1..-1].to_i] }.each do |s|

          # {"Lot"=>"1a", "Supplier"=>"Hirthe-Mills",
          # "Pre-School"=>1.3418903988675766, "Warehouses"=>0.6778947368421055,
          # "Service Ref"=>"C.1", "Service Name"=>"Mechanical and Electrical Engineering Maintenance - Standard A", "Primary School"=>1.3418903988675766, "Special Schools"=>1.3418903988675766, "Unit of Measure"=>"Square Metre (GIA) per annum", "Secondary Schools"=>1.3418903988675766, "Call Centre Operations"=>1.84, "Nursing and Care Homes"=>1.3418903988675766, "Universities and Colleges"=>1.3418903988675766, "General office - Customer Facing"=>1.84, "Restaurant and Catering Facilities"=>1.84, "General office - Non Customer Facing"=>1.84, "Community - Doctors, Dentist, Health Clinic"=>2.5161395965423625}

          labels = @data.keys.sort.collect do |k|
            @data[k][s][:spreadsheet_label]
          end

          new_row = []
          CCS::FM::RateCard.building_types.each do |b|
            new_row << @rate_card_data[:Prices][@supplier_name.to_sym][s.to_sym][b]
          end

          new_row = ([s, rate_card_prices[s.to_sym][:'Service Name'], labels.first] << new_row).flatten

          sheet.add_row new_row
        end

        sheet.add_row
        sheet.add_row
        sheet.add_row ['Table 2. Pricing Variables']
        sheet.add_row ['Cost type', 'Unit of Measure', 'Rate']

        sheet.add_row ['Cleaning Consumables', 'price per building occupant per annum', rate_card_variances[:'Cleaning Consumables per Building User (£)']]
        sheet.add_row ['Management Overhead', 'percentage of deliverables value', rate_card_variances[:"Management Overhead %"]]
        sheet.add_row ['Corporate Overhead', 'percentage of deliverables value', rate_card_variances[:"Corporate Overhead %"]]
        sheet.add_row ['Profit', 'percentage of deliverables value', rate_card_variances[:'Profit %']]
        sheet.add_row ['London Location Variance Rate', 'variance to standard service rate', rate_card_variances[:'London Location Variance Rate (%)']]
        sheet.add_row ['TUPE Risk Premium', 'percentage of deliverables value', rate_card_variances[:'TUPE Risk Premium (DA %)']]
        sheet.add_row ['Mobilisation Cost', 'percentage of deliverables value', rate_card_variances[:'Mobilisation Cost (DA %)']]

      end
    end
  end
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/BlockLength
  # rubocop:disable Metrics/MethodLength
  def contract_price_matrix
    @workbook.add_worksheet(name: 'Contract Price Matrix') do |sheet|
      sheet.add_row
      sheet.add_row ['Table 1. Baseline service costs for year 1']
      new_row = ['Service Reference', 'Service Name', 'Total']
      @data.keys.sort.each.with_index do |_k, idx|
        new_row << 'Building ' + (idx + 1).to_s
      end
      sheet.add_row new_row

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
          new_row2 = []
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
        sheet.add_row new_row
      end

      new_row = ['Planned Deliverables sub total', nil, sumsum]
      sorted_building_keys.each do |k|
        new_row << sum_building[k]
      end
      sheet.add_row new_row

      sheet.add_row

      add_computed_row sheet, sorted_building_keys, 'CAFM', sum_building_cafm

      add_computed_row sheet, sorted_building_keys, 'Helpdesk', sum_building_helpdesk

      # sheet.add_row ['Year 1 Deliverables sub total']
      add_summation_row sheet, sorted_building_keys, 'Year 1 Deliverables sub total', 4
      sheet.add_row

      add_computed_row sheet, sorted_building_keys, 'London Location Variance', sum_building_variance

      # sheet.add_row ['Year 1 Deliverables total']
      add_summation_row sheet, sorted_building_keys, 'Year 1 Deliverables total', 3
      sheet.add_row

      add_computed_row sheet, sorted_building_keys, 'Mobilisation', sum_building_mobilisation

      add_computed_row sheet, sorted_building_keys, 'TUPE Risk Premium', sum_building_tupe

      # sheet.add_row ['Total Charges excluding Overhead and Profit']
      add_summation_row sheet, sorted_building_keys, 'Total Charges excluding Overhead and Profit', 4
      sheet.add_row

      add_computed_row sheet, sorted_building_keys, 'Management Overhead', sum_building_manage

      add_computed_row sheet, sorted_building_keys, 'Corporate Overhead', sum_building_corporate

      add_summation_row sheet, sorted_building_keys, 'Total Charges excluding Profit', 4

      add_computed_row sheet, sorted_building_keys, 'Profit', sum_building_profit

      add_summation_row sheet, sorted_building_keys, 'Total Charges year 1', 2

      sheet.add_row
      sheet.add_row ['Table 2. Subsequent Years Total Charges']
      # @data["E7EED6F6-5EF0-E387-EE35-6C1D39FEB8A9"].first[1][:subsequent_length_years]
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
        sheet.add_row new_row2
      end

      sheet.add_row
      add_summation_row sheet, sorted_building_keys, 'Total Charge (total contract cost)', max_years + 3
      sheet.add_row
      sheet.add_row ['Table 3. Total charges per month']
      new_row = new_row.map { |x| x / 12 }
      (1..max_years).each do |i|
        new_row2 = ["Year #{i} Monthly cost", nil, sumsum / 12]
        sheet.add_row new_row2
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/BlockLength
  # rubocop:enable Metrics/AbcSize
end
