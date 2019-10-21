class FacilitiesManagement::DirectAwardSpreadsheet
  def initialize(data)
    @data = data
    create_spreadsheet
  end

  def to_xlsx
    @package.to_stream.read
  end

  private

  def create_spreadsheet
    @package = Axlsx::Package.new
    @workbook = @package.workbook

    @workbook.add_worksheet(name: 'Contract Price Matrix') do |sheet|
    end

    @workbook.add_worksheet(name: 'Contract Rate Card') do |sheet|
    end
  end
end
