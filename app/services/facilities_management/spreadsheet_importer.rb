class FacilitiesManagement::SpreadsheetImporter
  def initialize(spreadsheet_import)
    @spreadsheet_import = spreadsheet_import
    @procurement = @spreadsheet_import.procurement
    @user = @procurement.user
    @user_uploaded_spreadsheet = Roo::Spreadsheet.open(downloaded_spreadsheet.path, extension: :xlsx)
    @errors = []
    @procurement_array = []
  end

  def basic_data_validation
    @errors << :template_invalid unless template_valid?
    @errors << :not_ready unless spreadsheet_ready?
    @errors
  end

  def import_data
    IMPORT_PROCESS_ORDER.each do |import_process|
      send(import_process)
      break if @errors.any?
    end
    if @errors.any?
      @spreadsheet_import.fail!
      return
    end

    if imported_spreadsheet_data_valid?
      save_spreadsheet_data
      @spreadsheet_import.succeed!
    else
      @spreadsheet_import.fail!
    end
  end

  # This can be added as more parts of the bulk upload are completed
  IMPORT_PROCESS_ORDER = %i[import_buildings add_procurement_buildings].freeze

  # We should store and validate all of the uploaded data first before we save it
  # My thinking is, as was suggested, to use an array which is laid out like follows
  # [{object: FacilitiesManagement::Building, valid: boolean, errors: Array, procurement_building:
  #     {object: FacilitiesManagement::ProcurementBuilding, valid: boolean, errors: Array, procurement_building_services:
  #       [ {object: FacilitiesManagement::ProcurementBuildingService, valid boolean, errors: Array}, ... ]
  #     }
  #  }, ...]
  # If any of the parent objects are invalid then we can leave it out within the data processing
  # We also need to store the errors so they can be fed back to the user after the upload process has been finished

  private

  # Importing buildings
  def import_buildings
    building_sheet = @user_uploaded_spreadsheet.sheet('Building Information')
    if buildings_complte?(building_sheet)
      columns = building_sheet.row(13).count('Complete')
      (2..columns + 1).each do |col|
        building_column = building_sheet.column(col)
        building = @user.buildings.build(user_email: @user.email,
                                         building_name: building_column[1],
                                         description: building_column[2],
                                         address_line_1: building_column[3],
                                         address_town: building_column[4],
                                         address_postcode: building_column[5],
                                         gia: building_column[6],
                                         external_area: building_column[7],
                                         building_type: building_column[8],
                                         other_building_type: building_column[9],
                                         security_type: building_column[10],
                                         other_security_type: building_column[11])
        add_regions(building, building_column)
        store_building(building)
      end
    else
      @errors << :building_incomplete
    end
  end

  def buildings_complte?(building_sheet)
    status_indicator = building_sheet.row(13).reject(&:empty?)
    status_indicator.shift
    status_indicator.count('Complete').positive? && status_indicator.reject { |status| status == 'Complete' }.empty?
  end

  def add_regions(building, building_column)
    region = Postcode::PostcodeCheckerV2.find_region building_column[5].to_s.delete(' ')
    (building.address_region_code = region[0]['code']) && (building.address_region = region[0]['region']) if region.count == 1
  end

  def store_building(building)
    building.populate_json_attribute
    validations = validate_building(building)
    @procurement_array << { object: building, valid: validations[0], errors: validations[1] }
  end

  def validate_building(building)
    building.valid?(:all)

    building.errors.delete(:building_name) if building.errors.details[:building_name].any? { |error| error[:error] == :taken }
    building.errors.delete(:address_region) if building.errors.details[:address_region].any?
    building.errors.add(:building_name, :taken) unless @procurement_array.none? { |building_value| building_value[:object].building_name == building.building_name }

    [building.errors.empty?, building.errors.details]
  end

  # Creating procurement buildings
  def add_procurement_buildings
    @procurement_array.each do |building|
      building[:procurement_building] = FacilitiesManagement::ProcurementBuilding.new(procurement: @procurement, active: true) if building[:valid]
    end
  end

  # Importing procurement building services with service standard
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
      procurement_building.update(service_codes: procurement_building.procurement_building_services.map(&:code))
    end
    @procurement.update(service_codes: @procurement.procurement_buildings.map(&:service_codes).flatten.uniq)
  end
  # rubocop:enable Metrics/AbcSize

  # Importing Service volumes 1
  # Importing Service volumes 2
  # Importing Service volumes 3

  def downloaded_spreadsheet
    tmpfile = Tempfile.create
    tmpfile.binmode
    tmpfile.write @spreadsheet_import.spreadsheet_file.download
    tmpfile.close
    tmpfile
  end

  def spreadsheet_ready?
    instructions_sheet = @user_uploaded_spreadsheet.sheet(0)
    instructions_sheet.row(10)[1] == 'Ready to upload'
  end

  TEMPLATE_FILE_PATH = Rails.root.join('public', 'RM3830 Customer Requirements Capture Matrix - template v2.4.xlsx')

  def template_valid?
    template_spreadsheet = Roo::Spreadsheet.open(TEMPLATE_FILE_PATH, extension: :xlsx)

    # The arrays are [sheet, column] - I've called sheets tabs in the iterator
    # Be aware sheets start from 0 (like an array), but columns start from 1
    columns = [
      [1, 1], # Building info
      [2, 1], [2, 2], [2, 3], # Service matrix
      [3, 1], [3, 2], [3, 4], # Service volumes 1
      [4, 1], [4, 2], [4, 4], [4, 5], # Service volumes 2
      [5, 1], [5, 2], [5, 4], # Service volumes 3
      [7, 2], # Compliance (hidden)
      [8, 1], [8, 2], [8, 4] # Lists (hidden)
    ]

    columns.each do |tab, col|
      return false if template_spreadsheet.sheet(tab).column(col) != @user_uploaded_spreadsheet.sheet(tab).column(col)
    end

    # Special case for list as has number of buildings at the end
    return false if template_spreadsheet.sheet(8).column(3)[0..-2] != @user_uploaded_spreadsheet.sheet(8).column(3)[0..-2]

    true
  end

  # Validate the import can continue
  def continue_import?(import_process)
    case import_process
    when :import_buildings
      @procurement_array.first != { error: :building_incomplete }
    else
      true
    end
  end

  # Validate the entire import
  def imported_spreadsheet_data_valid?
    @procurement_array.all? { |building| building[:valid] }
  end

  # Save the entire import
  def save_spreadsheet_data
    # delete existing procurement data
    @procurement_array.each_with_index do |building, index|
      save_building(building[:object], index)
      building[:object].reload
    end
  end

  # def delete_existing_procurement_buildings_and_services
  #   @procurement.procurement_buildings.each do |pb|
  #     pb.building.destroy
  #     pb.destroy
  #   end
  # end

  def save_building(building, index)
    exsisting_building = @user.buildings.find_by(building_name: building.building_name)
    if exsisting_building.nil?
      building.save
    else
      if building.address_region.nil? && nomralise_postcode(exsisting_building.address_postcode) == nomralise_postcode(building.address_postcode)
        exsisting_building.assign_attributes(building.attributes.except('id', 'created_at', 'updated_at', 'address_region', 'address_region_code', 'building_json'))
      else
        exsisting_building.assign_attributes(building.attributes.except('id', 'created_at', 'updated_at', 'building_json'))
      end
      exsisting_building.save
      @procurement_array[index][:object] = exsisting_building
    end
  end

  def nomralise_postcode(postcode)
    postcode.gsub(' ', '').downcase
  end
end
