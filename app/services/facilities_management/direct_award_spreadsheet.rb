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

      @data.keys.collect { |k| @data[k].keys }
           .flatten.uniq
           .sort_by { |code| [code[0..code.index('.') - 1], code[code.index('.') + 1..-1].to_i] }.each do |s|

        new_row = [s, FacilitiesManagement::Service.where(code: s).first.name]

        new_row2 = []
        sum = 0
        sorted_building_keys.each do |k|
          new_row2 << @data[k][s]
          sum += @data[k][s]
        end

        new_row = (new_row << sum << new_row2).flatten
        sheet.add_row new_row
      end
    end

    @workbook.add_worksheet(name: 'Contract Rate Card') do |sheet|
      sheet.add_row [@supplier_name]
    end
  end
  # rubocop:enable Metrics/AbcSize
end
