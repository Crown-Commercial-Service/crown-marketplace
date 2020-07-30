class FacilitiesManagement::SpreadsheetImporter
  def initialize(spreadsheet_import_id)
    @spreadsheet_import = FacilitiesManagement::SpreadsheetImport.find(spreadsheet_import_id)
    @procurement = @spreadsheet_import.procurement
    @user = @procurement.user
    @spreadsheet = Roo::Spreadsheet.open(path_to_spreadsheet, extension: :xlsx)

    instructions_sheet = @spreadsheet.sheet(0)
    if instructions_sheet.row(10)[1] == 'Ready to upload'
      import_buildings
      import_services
      @spreadsheet_import.succeed!
    else
      @spreadsheet_import.fail!
    end
  end

  def import_buildings
    building_sheet = @spreadsheet.sheet(2)
    columns = building_sheet.row(14).count('Complete')
    (2..columns+1).each do |col|
      building_column = building_sheet.column(col)
      building = FacilitiesManagement::Building.create(user: @user,
                                                       user_email: @user.email,
                                                       building_name: building_column[1],
                                                       description: building_column[2],
                                                       address_line_1: building_column[3],
                                                       address_line_2:building_column[4],
                                                       address_town: building_column[5],
                                                       address_postcode:building_column[6],
                                                       external_area:building_column[8],
                                                       gia:building_column[7],
                                                       building_type:building_column[9],
                                                       other_building_type:building_column[10],
                                                       security_type:building_column[11],
                                                       other_security_type:building_column[12])
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

  def import_services
    services_sheet = @spreadsheet.sheet(3)
    columns = services_sheet.row(1).count('OK')
    (3..columns+2).each do |col|
      building_column = services_sheet.column(col)
      building_name = building_column[1]
      procurement_building = @procurement.procurement_buildings.select{|pb| pb.building.building_name == building_name}.first
      services_indexes = building_column.each_index.select{|i| building_column[i] == 'Yes'}
      services_indexes.each do |index|
        service_name = services_sheet.row(index+1)[0]
        fm_service = FacilitiesManagement::Service.all.select{|s| service_name.downcase.start_with?(s.name.downcase)}.first
        service_standard = fm_service.name.length < service_name.length ? service_name[service_name.length - 1] : nil
        FacilitiesManagement::ProcurementBuildingService.create(procurement_building: procurement_building, code: fm_service.code, name: fm_service.name, service_standard: service_standard)
      end
      procurement_building.update_attribute(:service_codes, procurement_building.procurement_building_services.map(&:code))
    end
    @procurement.update_attribute(:service_codes, @procurement.procurement_buildings.map(&:service_codes).flatten.uniq)
  end

  def path_to_spreadsheet
    @spreadsheet_import.spreadsheet_file.path
  end

  # def delete_existing_procurement_buildings_and_services
  #   @procurement.procurement_buildings.each do |pb|
  #     pb.building.destroy
  #     pb.destroy
  #   end
  # end
end