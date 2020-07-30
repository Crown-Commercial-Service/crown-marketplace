class FacilitiesManagement::SpreadsheetImporter
  def initialize(user, procurement)
    @user = user
    @procurement = procurement
    @spreadsheet = Roo::Spreadsheet.open(path_to_spreadsheet, extension: :xlsx)

    instructions_sheet = @spreadsheet.sheet(0)
    if (instructions_sheet.row(10)[1] == 'Ready to upload')
      import_buildings
      # import_services
    end
  end

  def import_buildings
    building_sheet = @spreadsheet.sheet(2)
    columns = building_sheet.row(13).count('Complete')
    (2..columns).each do |col|
      building_column = building_sheet.column(col)
      building = FacilitiesManagement::Building.create(user: @user,
                                                       user_email: @user.email,
                                                       building_name: building_column[2],
                                                       description: building_column[3],
                                                       address_line_1: building_column[4],
                                                       address_line_2:building_column[5],
                                                       address_town: building_column[6],
                                                       address_postcode:building_column[6],
                                                       other_building_type:building_column[10],
                                                       other_security_type:building_column[12],
                                                       external_area:building_column[8],
                                                       gia:building_column[7],
                                                       building_type:building_column[9],
                                                       security_type:building_column[11])
      building.populate_json_attribute
      building.save
      procurement_building = FacilitiesManagement::ProcurementBuilding.create(procurement: @procurement, building_id: building.id, active: true)
      procurement_building.save
    end
  end

  def path_to_spreadsheet
    Rails.root.join('data','facilities_management','RM3830 Customer Requirements Capture Matrix - template v2.3.xlsx')
  end
end