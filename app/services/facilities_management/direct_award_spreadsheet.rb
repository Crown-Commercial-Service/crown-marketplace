class FacilitiesManagement::DirectAwardSpreadsheet
  def initialize(supplier_name, data)
    @supplier_name = supplier_name
    @data = data
    create_spreadsheet
  end

  def to_xlsx
    @package.to_stream.read
  end

  private

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/BlockLength
  def create_spreadsheet
    @package = Axlsx::Package.new
    @workbook = @package.workbook

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
      sorted_building_keys.each do |k|
        sum_building[k] = 0
        sum_building_cafm[k] = 0
        sum_building_helpdesk[k] = 0
        sum_building_variance[k] = 0
        sum_building_tupe[k] = 0
        sum_building_manage[k] = 0
        sum_building_corporate[k] = 0
        sum_building_profit[k] = 0
      end
      @data.keys.collect { |k| @data[k].keys }
           .flatten.uniq
           .sort_by { |code| [code[0..code.index('.') - 1], code[code.index('.') + 1..-1].to_i] }.each do |s|

        new_row = [s, FacilitiesManagement::Service.where(code: s).first.name]

        new_row2 = []
        sum = 0
        sorted_building_keys.each do |k|
          new_row2 << @data[k][s][:year1totalcharges]
          sum += @data[k][s][:year1totalcharges]

          sum_building[k] += @data[k][s][:year1totalcharges]
          sum_building_cafm[k] += @data[k][s][:cafm]
          sum_building_helpdesk[k] += @data[k][s][:helpdesk]
          sum_building_variance[k] += @data[k][s][:variance]
          sum_building_tupe[k] += @data[k][s][:tupe]
          sum_building_manage[k] += @data[k][s][:manage]
          sum_building_corporate[k] += @data[k][s][:corporate]
          sum_building_profit[k] += @data[k][s][:profit]
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
      sheet.add_row ['CAFM']
      sheet.add_row ['Helpdesk']
      sheet.add_row ['Year 1 Deliverables sub total']
      sheet.add_row
      sheet.add_row ['London Location Variance']
      sheet.add_row ['Year 1 Deliverables total']
      sheet.add_row
      sheet.add_row ['Mobilisation']
      sheet.add_row ['TUPE Risk Premium']
      sheet.add_row ['Total Charges excluding Overhead and Profit']
      sheet.add_row
      sheet.add_row ['Management Overhead']
      sheet.add_row ['Corporate Overhead']
      sheet.add_row ['Total Charges excluding Profit']
      sheet.add_row ['Profit']
      sheet.add_row ['Total Charges year 1']
      sheet.add_row
      sheet.add_row ['Table 2. Subsequent Years Total Charges']
      sheet.add_row ['Year 2']
      sheet.add_row ['Year 3']
      sheet.add_row ['Year 4']
      sheet.add_row
      sheet.add_row ['Total Charge (total contract cost)']
      sheet.add_row
      sheet.add_row ['Table 3. Total charges per month']
      sheet.add_row ['Year 1 Monthly cost']
      sheet.add_row ['Year 2 Monthly cost']
      sheet.add_row ['Year 3 Monthly cost']
      sheet.add_row ['Year 4 Monthly cost']
    end

    @workbook.add_worksheet(name: 'Contract Rate Card') do |sheet|
      sheet.add_row [@supplier_name]
    end
  end
  # rubocop:enable Metrics/BlockLength
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize
end
