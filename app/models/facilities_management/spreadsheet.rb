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
  # rubocop:disable Metrics/PerceivedComplexity
  # rubocop:disable Metrics/CyclomaticComplexity
  def create_spreadsheet
    @package = Axlsx::Package.new
    @workbook = @package.workbook

    selected_buildings = @report.user_buildings

    services_selected = selected_buildings.collect { |b| b.building_json['services'] }.flatten # s.collect { |s| s['code'].gsub('-', '.') }
    services_selected.uniq!

    # services_selected.sort_by(&:code)

    # (FacilitiesManagement::Service.all.sort_by (&:code)).each { |s| sheet.add_row [ s.work_package_code s.code ] }
    # services = @report.selected_services(services_selected).sort_by(&:code)
    # selected_services = services.collect(&:code)

    # selected_buildings = @report.building_data.select do |b|
    #   if b.building_json['services']
    #     b_services = b.building_json['services'].map { |s| s['code'] }
    #     (selected_services & b_services).any?
    #   else
    #     false
    #   end
    # end

    @workbook.add_worksheet(name: 'Building Information') do |sheet|
      sheet.add_row ['Buildings information']
      i = 0
      ['Building Type', 'Name', 'Address', '', '', '', 'GIA'].each do |label|
        vals = row(selected_buildings, i)
        sheet.add_row [label] + vals
        i += 1
      end
    end

    selected_services = services_selected.map { |s| s['code'].gsub('-', '.') }
    services = @report.selected_services(selected_services)

    @workbook.add_worksheet(name: 'Service Matrix') do |sheet|
      i = 1
      vals = ['Work Package', 'Service Reference', 'Service Name', 'Measurement']
      selected_buildings.each do |building|
        vals << 'Building ' + i.to_s + ' - ' + building.building_json['name']
        i += 1
      end
      sheet.add_row vals

      work_package = ''

      services.sort_by { |s| [s.work_package_code, s.code[s.code.index('.') + 1..-1].to_i] }.each do |s|
        if work_package == s.work_package_code
          label = nil
        else
          label = 'Work Package ' + s.work_package_code + ' - ' + s.work_package.name
        end

        work_package = s.work_package_code

        vals = [label, s.code, s.name]

        vals_v = []
        vals_h = nil
        uom_labels_2d = []
        selected_buildings.each do |building|
          # begin
          id = building.building_json['id']
          suv = @report.uom_values(selected_buildings).select { |v| v['building_id'] == id && v['service_code'] == s.code }
          vals_h = []

          uom_labels = []
          suv.each do |v|
            uom_labels << v['title_text']

            vals_h << v['uom_value']
          end
          vals_v << vals_h
          uom_labels_2d << uom_labels
        rescue StandardError
          vals << '=NA()'
        end
        # vals << valsV
        # sheet.add_row vals
        #

        uom_labels_max = uom_labels_2d.max
        # uoms.each do |u|
        # vals << u['title_text']building_json['services'].map { |s| s['code'] }
        max_j = vals_v.map(&:length).max
        if max_j
          (0..max_j - 1).each do |j|
            if j.zero?
              vals << uom_labels_max[j]
            elsif uom_labels_max[j - 1] == uom_labels_max[j]
              vals << nil
            else
              vals << uom_labels_max[j]
            end

            (0..vals_v.count - 1).each do |k|
              vals << vals_v[k][j]
            end
            sheet.add_row vals
            # vals = [nil, nil, nil, nil]
            vals = [nil, nil, nil]
          end
        end
        # end
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
      # sheet.add_row ['4. Supplier Shortlist']
      label = '4. Supplier Shortlist'
      @report.selected_suppliers(@current_lot).each do |supplier|
        sheet.add_row [label, supplier.data['supplier_name']]
        label = nil
      end
      sheet.add_row

      # sheet.add_row ['5. Regions summary']
      label = '5. Regions summary'
      FacilitiesManagement::Region.all.select { |region| @data['posted_locations'].include? region.code }.each do |region|
        sheet.add_row [label, region.name]
        label = nil
      end
      sheet.add_row

      # sheet.add_row ['6 Services summary']
      services = FacilitiesManagement::Service.where(code: @data['posted_services'])
      services.sort_by!(&:code)
      label = '6 Services summary'
      services.each do |s|
        sheet.add_row [label, s.name]
        label = nil
      end
      sheet.add_row
    end
    # package.to_stream.read
  end
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Style/ConditionalAssignment
  # rubocop:enable Metrics/BlockLength
end
