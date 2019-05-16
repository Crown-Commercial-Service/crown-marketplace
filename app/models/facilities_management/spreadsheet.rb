class FacilitiesManagement::Spreadsheet
  def initialize(report)
    @report = report
    create_spreadsheet
  end

  # rubocop:disable Metrics/CyclomaticComplexity
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
          building.building_json['gia']
        end
      vals << str
    end
    vals
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def to_xlsx
    @package.to_stream.read
  end

  private

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Style/ConditionalAssignment
  # rubocop:disable Metrics/BlockLength
  def create_spreadsheet
    @package = Axlsx::Package.new
    @workbook = @package.workbook

    @workbook.add_worksheet(name: 'Building Information') do |sheet|
      sheet.add_row ['Buildings information']
      i = 0
      ['Building Type', 'Name', 'Address', '', '', '', 'GIA'].each do |label|
        vals = row(@report, i)
        sheet.add_row [label] + vals
        i += 1
      end
    end

    @workbook.add_worksheet(name: 'Service Matrix') do |sheet|
      @uom_values = @report.uom_values
      i = 1
      vals = ['Work Package', 'Service Reference', 'Service Name', 'Measurement', 'Unit of Measure']
      @report.building_data.each do |building|
        vals << 'Building ' + i.to_s + ' - ' + building.building_json['name']
        i += 1
      end
      sheet.add_row vals

      # (FacilitiesManagement::Service.all.sort_by (&:code)).each { |s| sheet.add_row [ s.work_package_code s.code ] }
      work_package = ''
      @report.selected_services
      services = @report.selected_services.sort_by(&:code)
      services.each do |s|
        if work_package == s.work_package_code
          label = nil
        else
          label = 'Work Package ' + s.work_package_code + ' ' + s.work_package.name
        end
        work_package = s.work_package_code

        uom = CCS::FM::UnitsOfMeasurement.service_usage(s.code)
        if uom.count.nonzero? # s.code == 'C.5' # uom.count.nonzero?
          vals = [label, s.code, s.name]
          uom.each do |u|
            vals << u['title_text']
            vals << u['unit_text']

            @report.building_data.each do |building|
              # begin
              id = building.building_json['id']
              vals << @uom_values[id][s.code]['uom_value']
            rescue StandardError
              vals << '=NA()'
              # end
            end
          end
          sheet.add_row vals
        else
          sheet.add_row [label, s.code, s.name]
        end

        work_package = s.work_package_code
      end
    end

    @workbook.add_worksheet(name: 'Procurement summary') do |sheet|
      date = sheet.styles.add_style(format_code: 'dd mmm yyyy', border: Axlsx::STYLE_THIN_BORDER)
      left_align = sheet.styles.add_style(alignment: { horizontal: :left })
      ccy = sheet.styles.add_style(format_code: '£#,##0')

      sheet.add_row ['CCS reference number & date/time of production of this document']
      sheet.add_row
      sheet.add_row ['1. Customer details']
      sheet.add_row ['Name']
      sheet.add_row ['Organisation']
      sheet.add_row ['Position']
      sheet.add_row ['Contact details']
      sheet.add_row ['']
      sheet.add_row ['2. Contract requirements']
      sheet.add_row ['Initial Contract length', @report.contract_length_years, 'years'], style: [nil, nil, left_align]
      sheet.add_row ['Extensions']
      sheet.add_row ['']
      sheet.add_row ['Tupe involvement', @report.tupe_flag]
      sheet.add_row ['']
      sheet.add_row ['Contract start date', @report.start_date.to_date], style: [nil, date]
      sheet.add_row ['']
      sheet.add_row ['3. Price and sub-lot recommendation']
      sheet.add_row ['Assessed Value', @report.assessed_value], style: [nil, ccy]
      sheet.add_row ['Assessed value estimated accuracy'], style: [nil, ccy]
      sheet.add_row ['']
      sheet.add_row ['Lot recommendation', @report.assessed_value]
      sheet.add_row ['Direct award option']
      sheet.add_row ['']
      sheet.add_row ['4. Supplier Shortlist']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['5. Regions summary']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['6 Services summary']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
      sheet.add_row ['']
    end
    # package.to_stream.read
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Style/ConditionalAssignment
  # rubocop:enable Metrics/BlockLength
end
