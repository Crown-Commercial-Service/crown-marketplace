class FacilitiesManagement::Spreadsheet
  class DataDownload
    include TelephoneNumberHelper

    def types
      %i[string string string string string]
    end

    def style(workbook, sheet); end
  end

  class Shortlist < DataDownload
    def sheet_name
      'Building Information'
    end

    def title
      ['Buildings information']
    end

    def headers
      ['Building Type', 'Name', 'Address', '', '', '', 'GIA']
    end

    def types
      super + [:float, nil, nil, nil]
    end
  end

  def initialize(report, with_calculations: false)
    @report = report
    @format = with_calculations ? Shortlist.new : DataDownload.new
  end

  def row(report, idx)
    vals = []
    report.building_data.each do |building|
      str =
        case idx
        when 0
          building.building_json['fm-building-type']
        when 1
          building.building_json['name']
        when 2
          building.building_json['address']['fm-address-line-1']
        when 3
          building.building_json['address']['fm-address-town']
        when 4
          building.building_json['address']['fm-address-county']
        when 5
          building.building_json['address']['fm-address-postcode']
        when 6
          building.building_json['fm-gross-internal-area']
        end
      vals << str
    end
    vals
  end

  def to_xlsx
    spreadsheet(@format.sheet_name) do |workbook, sheet|
      sheet.add_row @format.title

      i = 0
      @format.headers.each do |label|
        vals = row(@report, i)
        sheet.add_row [label] + vals, types: @format.types
        i += 1
      end

      @format.style(workbook, sheet)
    end
  end

  private

  def spreadsheet(name)
    package = Axlsx::Package.new
    workbook = package.workbook
    workbook.add_worksheet(name: name) do |sheet|
      yield workbook, sheet
    end
    package.to_stream.read
  end
end
