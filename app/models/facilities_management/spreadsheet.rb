class FacilitiesManagement::Spreadsheet
  def initialize(report, current_lot, data)
    @report = report
    @current_lot = current_lot
    @data = data
    create_spreadsheet
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def row(buildings, idx)
    vals = []
    buildings.each do |building|
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

    # (FacilitiesManagement::Service.all.sort_by (&:code)).each { |s| sheet.add_row [ s.work_package_code s.code ] }
    services = @report.selected_services.sort_by(&:code)
    selected_services = services.collect(&:code)
    selected_services = selected_services.map { |s| s.gsub('.', '-') }
    selected_buildings = @report.building_data.select do |b|
      b_services = b.building_json['services'].map { |s| s['code'] }
      (selected_services & b_services).any?
    end

    @workbook.add_worksheet(name: 'Building Information') do |sheet|
      sheet.add_row ['Buildings information']
      i = 0
      ['Building Type', 'Name', 'Address', '', '', '', 'GIA'].each do |label|
        vals = row(selected_buildings, i)
        sheet.add_row [label] + vals
        i += 1
      end
    end

    @workbook.add_worksheet(name: 'Service Matrix') do |sheet|
      @uom_values = @report.uom_values

      i = 1
      vals = ['Work Package', 'Service Reference', 'Service Name', 'Measurement', 'Unit of Measure']
      selected_buildings.each do |building|
        vals << 'Building ' + i.to_s + ' - ' + building.building_json['name']
        i += 1
      end
      sheet.add_row vals

      work_package = ''
      services.each do |s|
        if work_package == s.work_package_code
          label = nil
        else
          label = 'Work Package ' + s.work_package_code + ' - ' + s.work_package.name
        end
        work_package = s.work_package_code

        uom = CCS::FM::UnitsOfMeasurement.service_usage(s.code)
        if uom.count.nonzero? # s.code == 'C.5' # uom.count.nonzero?
          vals = [label, s.code, s.name]
          uom.each do |u|
            vals << u['title_text']
            vals << u['unit_text']

            selected_buildings.each do |building|
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
      sheet.add_row
      sheet.add_row ['2. Contract requirements']
      sheet.add_row ['Initial Contract length', @report.contract_length_years, 'years'], style: [nil, nil, left_align]
      sheet.add_row ['Extensions']
      sheet.add_row
      sheet.add_row ['Tupe involvement', @report.tupe_flag]
      sheet.add_row
      sheet.add_row ['Contract start date', @report.start_date&.to_date], style: [nil, date]
      sheet.add_row
      sheet.add_row ['3. Price and sub-lot recommendation']
      sheet.add_row ['Assessed Value', @report.assessed_value], style: [nil, ccy]
      sheet.add_row ['Assessed value estimated accuracy'], style: [nil, ccy]
      sheet.add_row
      sheet.add_row ['Lot recommendation', @report.current_lot]
      sheet.add_row ['Direct award option']
      sheet.add_row
      sheet.add_row ['4. Supplier Shortlist']
      @report.selected_suppliers(@current_lot).each do |supplier|
        sheet.add_row [nil, supplier.data['supplier_name']]
      end
      sheet.add_row

      sheet.add_row ['5. Regions summary']
      FacilitiesManagement::Region.all.select { |region| @data['posted_locations'].include? region.code }.each do |region|
        sheet.add_row [nil, region.name]
      end
      sheet.add_row

      sheet.add_row ['6 Services summary']
      services = FacilitiesManagement::Service.where(code: @data['posted_services'])
      services.sort_by!(&:code)
      services.each do |s|
        sheet.add_row [nil, s.name]
      end
      sheet.add_row
    end
    # package.to_stream.read
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Style/ConditionalAssignment
  # rubocop:enable Metrics/BlockLength
end
