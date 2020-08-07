class FacilitiesManagement::SpreadsheetImporter
  def initialize(spreadsheet_import)
    @spreadsheet_import = spreadsheet_import
    @procurement = @spreadsheet_import.procurement
    @user = @procurement.user
    @user_uploaded_spreadsheet = Roo::Spreadsheet.open(downloaded_spreadsheet.path, extension: :xlsx)
  end

  def basic_data_validation
    errors = []

    errors << :template_invalid unless template_valid?
    errors << :not_ready unless spreadsheet_ready?
    errors
  end

  def data_import
    import_buildings
    import_services
    @spreadsheet_import.succeed!
  end

  # rubocop:disable Metrics/AbcSize
  def import_buildings
    building_sheet = @user_uploaded_spreadsheet.sheet(2)
    columns = building_sheet.row(14).count('Complete')
    (2..columns + 1).each do |col|
      building_column = building_sheet.column(col)
      building = FacilitiesManagement::Building.create(user: @user,
                                                       user_email: @user.email,
                                                       building_name: building_column[1],
                                                       description: building_column[2],
                                                       address_line_1: building_column[3],
                                                       address_line_2: building_column[4],
                                                       address_town: building_column[5],
                                                       address_postcode: building_column[6],
                                                       external_area: building_column[8],
                                                       gia: building_column[7],
                                                       building_type: building_column[9],
                                                       other_building_type: building_column[10],
                                                       security_type: building_column[11],
                                                       other_security_type: building_column[12])
      region = Postcode::PostcodeCheckerV2.find_region building_column[6].delete(' ')
      if region.count == 1
        building.address_region_code = region[0]['code']
        building.address_region = region[0]['region']
      end
      building.populate_json_attribute
      building.save
      procurement_building = FacilitiesManagement::ProcurementBuilding.create(procurement: @procurement, building_id: building.id, active: true)
      procurement_building.save
    end
  end
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable Metrics/AbcSize
  def import_services
    services_sheet = @user_uploaded_spreadsheet.sheet(3)
    columns = services_sheet.row(1).count('OK')
    (3..columns + 2).each do |col|
      building_column = services_sheet.column(col)
      building_name = building_column[1]
      procurement_building = @procurement.procurement_buildings.select { |pb| pb.building.building_name == building_name }.first
      services_indexes = building_column.each_index.select { |i| building_column[i] == 'Yes' }
      services_indexes.each do |index|
        service_name = services_sheet.row(index + 1)[0]
        fm_service = FacilitiesManagement::Service.all.select { |s| service_name.downcase.start_with?(s.name.downcase) }.first
        service_standard = fm_service.name.length < service_name.length ? service_name[service_name.length - 1] : nil
        FacilitiesManagement::ProcurementBuildingService.create(procurement_building: procurement_building, code: fm_service.code, name: fm_service.name, service_standard: service_standard)
      end
      procurement_building.update(:service_codes, procurement_building.procurement_building_services.map(&:code))
    end
    @procurement.update(:service_codes, @procurement.procurement_buildings.map(&:service_codes).flatten.uniq)
  end
  # rubocop:enable Metrics/AbcSize

  def downloaded_spreadsheet
    tmpfile = Tempfile.create
    tmpfile.binmode
    tmpfile.write @spreadsheet_import.spreadsheet_file.download
    tmpfile.close
    tmpfile
  end

  private

  def spreadsheet_ready?
    instructions_sheet = @user_uploaded_spreadsheet.sheet(0)
    instructions_sheet.row(10)[1] == 'Ready to upload'
  end

  def template_valid?
    path = Rails.root.join('public', 'RM3830 Customer Requirements Capture Matrix - template v2.4.xlsx')
    template_spreadsheet = Roo::Spreadsheet.open(path, extension: :xlsx)

    # The arrays are [sheet, column] - I've called sheets tabs in the iterator
    # Be aware sheets start from 0 (like an array), but columns start from 1
    columns = [
      [1, 1], # Building info
      [2, 1], [2, 2], [2, 3], # Service matrix
      [3, 1], [3, 2], [3, 4], # Service volumes 1
      [4, 1], [4, 2], [4, 4], [4, 5], # Service volumes 2
      [5, 1], [5, 2], [5, 4], # Service volumes 3
      [7, 2], # Compliance (hidden)
      [8, 1], [8, 2], [8, 3], [8, 4] # Lists (hidden)
    ]

    columns.each do |tab, col|
      return false if template_spreadsheet.sheet(tab).column(col) != @user_uploaded_spreadsheet.sheet(tab).column(col)
    end

    true
  end
end
