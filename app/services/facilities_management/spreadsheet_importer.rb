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
    if !template_valid?
      @errors << :template_invalid
    elsif spreadsheet_not_started?
      @errors << :not_started
    elsif spreadsheet_not_ready?
      @errors << :not_ready if spreadsheet_not_ready?
    end
    @errors
  end

  # This can be added as more parts of the bulk upload are completed
  IMPORT_PROCESS_ORDER = %i[import_buildings add_procurement_buildings import_service_matrix import_service_volumes import_lift_data import_service_hours validate_procurement_building_services].freeze

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

    if sheet_complete?(building_sheet, 13, 'Complete')
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
      building[:procurement_building] = { object: FacilitiesManagement::ProcurementBuilding.new(procurement: @procurement, active: true), procurement_building_services: [] }
    end
  end

  # Importing procurement building services with service standard
  SERVICE_CODES = %w[C.1a C.1b C.1c C.2a C.2b C.2c C.3a C.3b C.3c C.4a C.4b C.4c C.6a C.6b C.6c C.7a C.7b C.7c C.11a C.11b C.11c C.12a C.12b C.12c C.13a C.13b C.13c C.5a C.5b C.5c C.14a C.14b C.14c C.8 C.9 C.10 C.15 C.16 C.17 C.18 C.19 C.20 C.21 C.22 D.1 D.2 D.3 D.4 D.5 D.6 E.1 E.2 E.3 E.5 E.6 E.7 E.8 E.4 E.9 F.1 F.2 F.3 F.4 F.5 F.6 F.7 F.8 F.9 F.10 G.1a G.1b G.1c G.2 G.3a G.3b G.3c G.4a G.4b G.4c G.6 G.7 G.15 G.5a G.5b G.5c G.9 G.8 G.10 G.11 G.12 G.13 G.14 G.16 H.4 H.5 H.7 H.1 H.2 H.3 H.6 H.8 H.9 H.10 H.11 H.12 H.13 H.14 H.15 H.16 I.1 I.2 I.3 I.4 J.1 J.2 J.3 J.4 J.5 J.6 J.7 J.8 J.9 J.10 J.11 J.12 K.2 K.3 K.1 K.7 K.4 K.5 K.6 L.1 L.2 L.3 L.4 L.5 L.6 L.7 L.8 L.9 L.10 L.11 M.1 N.1 O.1].freeze

  def import_service_matrix
    matrix_sheet = @user_uploaded_spreadsheet.sheet('Service Matrix')
    if sheet_complete?(matrix_sheet, 1, 'OK') && sheet_contains_all_buildings?(matrix_sheet, 2, 1)
      columns = matrix_sheet.row(1).count('OK')
      (5..columns + 4).each_with_index do |col, index|
        get_service_codes(matrix_sheet, col, index)
      end
    else
      @errors << :service_matrix_incomplete
    end
  end

  def get_service_codes(matrix_sheet, col, index)
    matrix_column = matrix_sheet.column(col)[3..-1].map { |value| value == 'Yes' }
    procurement_building_hash = @procurement_array[index][:procurement_building]
    procurement_building = procurement_building_hash[:object]
    procurement_building_services = procurement_building_hash[:procurement_building_services]

    matrix_column.each_with_index do |service, i|
      next unless service

      code = extract_code(SERVICE_CODES[i])

      break if check_for_duplicate_code(procurement_building, procurement_building_hash, code)

      procurement_building.service_codes << code
      add_procurement_building_service(procurement_building_services, code, i)
    end

    validate_procurement_building(procurement_building_hash, @procurement_array[index][:object])
  end

  def check_for_duplicate_code(procurement_building, procurement_building_hash, code)
    if procurement_building.service_codes.include? code
      procurement_building_hash[:valid] = false
      procurement_building_hash[:errors] = { service_codes: [{ error: :multiple_standards_for_one_service }] }
      return true
    end

    false
  end

  def add_procurement_building_service(procurement_building_services, code, index)
    procurement_building_service = FacilitiesManagement::ProcurementBuildingService.new(code: code)
    procurement_building_service.service_standard = extract_standard(SERVICE_CODES[index]) if requires_service_standard?(SERVICE_CODES[index])
    procurement_building_services << { object: procurement_building_service }
  end

  def extract_code(code)
    if requires_service_standard?(code)
      code[0..-2]
    else
      code
    end
  end

  def requires_service_standard?(code)
    ['a', 'b', 'c'].include? code[-1]
  end

  def extract_standard(code)
    code.last.upcase
  end

  def validate_procurement_building(procurement_building_hash, building)
    return if procurement_building_hash[:valid] == false

    procurement_building = procurement_building_hash[:object]

    procurement_building.valid?(:building_services)
    procurement_building.valid?(:procurement_building_services_present)
    procurement_building.validate_spreadsheet_gia(building.gia, building.building_name)
    procurement_building.validate_spreadsheet_external_area(building.external_area, building.building_name)

    procurement_building_hash[:valid] = procurement_building.errors.empty?
    procurement_building_hash[:errors] = procurement_building.errors.details
  end

  # Importing Service volumes 1
  VOLUME_CODES = %w[E.4 G.1 G.3 K.1 K.2 K.3 K.4 K.5 K.6 K.7].freeze

  def import_service_volumes
    service_volume_sheet = @user_uploaded_spreadsheet.sheet('Service Volumes 1')
    if sheet_complete?(service_volume_sheet, 1, 'OK') && sheet_contains_all_buildings?(service_volume_sheet, 3, 4)
      columns = service_volume_sheet.row(1).count('OK')
      (5..columns + 4).each_with_index do |col, building_index|
        service_volume_column = service_volume_sheet.column(col)
        services = {}

        VOLUME_CODES.each_with_index do |code, index|
          services[code] = service_volume_column[index + 3].to_i
        end

        add_service_volumes(services, building_index)
      end
    else
      @errors << :volumes_incomplete
    end
  end

  def add_service_volumes(services, building_index)
    procurement_building_services = @procurement_array[building_index][:procurement_building][:procurement_building_services].map { |pbs| pbs[:object] }
    procurement_building_services.each do |pbs|
      next unless VOLUME_CODES.include?(pbs.code)

      volume = pbs.required_contexts[:volume].first
      pbs[volume] = services[pbs.code]
    end
  end

  # Importing Service volumes 2
  def import_lift_data
    service_volume_lifts_sheet = @user_uploaded_spreadsheet.sheet('Service Volumes 2')
    if sheet_complete?(service_volume_lifts_sheet, 1, 'OK') && sheet_contains_all_buildings?(service_volume_lifts_sheet, 2, 1)
      columns = service_volume_lifts_sheet.row(1).count('OK')
      (6..columns + 5).each_with_index do |col, building_index|
        procurement_building_service = @procurement_array[building_index][:procurement_building][:procurement_building_services].map { |pbs| pbs[:object] }.select { |pbs| pbs.code == 'C.5' }.first
        next if procurement_building_service.nil?

        service_volume_column = service_volume_lifts_sheet.column(col)[6..-2]

        next if missing_lifts?(service_volume_column, service_volume_lifts_sheet.column(col)[3])

        procurement_building_service.lift_data = get_lift_data(service_volume_column)
      end
    else
      @errors << :lifts_incomplete
    end
  end

  def missing_lifts?(lifts, number_of_lifts)
    lifts.compact.count != number_of_lifts
  end

  NUMBER_OF_LIFTS = 40

  def get_lift_data(service_volume_column)
    lifts = []

    NUMBER_OF_LIFTS.times do |row|
      lift_data = service_volume_column[row]
      break if lift_data.nil?

      lifts << lift_data.to_i
    end

    lifts
  end

  # Importing Service hours
  SERVICE_HOUR_CODES = %w[H.4 H.5 I.1 I.2 I.3 I.4 J.1 J.2 J.3 J.4 J.5 J.6].freeze

  def import_service_hours
    service_hours_sheet = @user_uploaded_spreadsheet.sheet('Service Volumes 3')
    if sheet_complete?(service_hours_sheet, 1, 'OK') && sheet_contains_all_buildings?(service_hours_sheet, 3, 4)
      columns = service_hours_sheet.row(1).count('OK')
      (5..columns + 4).each_with_index do |col, index|
        procurement_building_hash = @procurement_array[index][:procurement_building]
        procurement_building = procurement_building_hash[:object]
        next if skip_building?(procurement_building)

        procurement_building_services = procurement_building_hash[:procurement_building_services]
        service_hours = get_service_hours_from_sheet(service_hours_sheet, col)
        add_service_hour_data(procurement_building_services.map { |pbs| pbs[:object] }, service_hours)
      end
    else
      @errors << :service_hours_incomplete
    end
  end

  def skip_building?(procurement_building)
    (procurement_building.service_codes & SERVICE_HOUR_CODES).empty?
  end

  def get_service_hours_from_sheet(sheet, col)
    service_hour_column = sheet.column(col)[3..-1]
    SERVICE_HOUR_CODES.map.with_index do |code, index|
      [code, { service_hours: service_hour_column[index * 2].to_i, detail_of_requirement: ActionController::Base.helpers.strip_tags(service_hour_column[index * 2 + 1].to_s) }]
    end.to_h
  end

  def add_service_hour_data(procurement_building_services, service_hours)
    procurement_building_services.each do |procurement_building_service|
      code = procurement_building_service.code
      next unless SERVICE_HOUR_CODES.include? code

      procurement_building_service.service_hours = service_hours[code][:service_hours]
      procurement_building_service.detail_of_requirement = service_hours[code][:detail_of_requirement]
    end
  end

  # Once all the services have been imported we should validate them like buildings and procurement_buildings
  def validate_procurement_building_services
    @procurement_array.each do |building|
      building[:procurement_building][:procurement_building_services].each do |procurement_building_service_hash|
        procurement_building_service = procurement_building_service_hash[:object]
        procurement_building_service.valid?(:all)

        procurement_building_service.errors.delete(:procurement_building)

        procurement_building_service_hash[:valid] = procurement_building_service.errors.empty?
        procurement_building_service_hash[:errors] = procurement_building_service.errors.details
      end
    end
  end

  def downloaded_spreadsheet
    tmpfile = Tempfile.create
    tmpfile.binmode
    tmpfile.write @spreadsheet_import.spreadsheet_file.download
    tmpfile.close
    tmpfile
  end

  def spreadsheet_not_ready?
    instructions_sheet = @user_uploaded_spreadsheet.sheet(0)
    if instructions_sheet.row(10)[1] != 'Ready to upload'
      Rails.logger.info 'Bulk upload: spreadsheet not ready'
      return true
    end

    false
  end

  def spreadsheet_not_started?
    instructions_sheet = @user_uploaded_spreadsheet.sheet(0)
    instructions_sheet.row(10)[1] == 'Awaiting Data Input'
  end

  TEMPLATE_FILE_NAME = 'RM3830 Customer Requirements Capture Matrix - template v2.6.1.xlsx'.freeze
  TEMPLATE_FILE_PATH = Rails.root.join('public', TEMPLATE_FILE_NAME).freeze

  def template_valid?
    template_spreadsheet = Roo::Spreadsheet.open(TEMPLATE_FILE_PATH, extension: :xlsx)

    return false if template_spreadsheet.sheets != @user_uploaded_spreadsheet.sheets

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
      if template_spreadsheet.sheet(tab).column(col) != @user_uploaded_spreadsheet.sheet(tab).column(col)
        Rails.logger.info "Bulk upload: column does not match template, sheet (start from 0): #{tab}, col (start from 1): #{col}, procurement id: #{@procurement.id}"
        return false
      end
    end

    # Special case for list as has number of buildings at the end
    return false if template_spreadsheet.sheet(8).column(3)[0..-2] != @user_uploaded_spreadsheet.sheet(8).column(3)[0..-2]

    true
  end

  # Shared methods
  def sheet_complete?(sheet, row, message)
    status_indicator = sheet.row(row).compact.reject(&:empty?)
    status_indicator.shift
    status_indicator.count(message).positive? && status_indicator.reject { |status| status == message }.empty?
  end

  def sheet_contains_all_buildings?(sheet, row, shift_number)
    buildings = @procurement_array.map { |building| building[:object].building_name }
    sheet_buildings = sheet.row(row).compact.reject(&:empty?)
    sheet_buildings.shift(shift_number)
    buildings == sheet_buildings
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
    building_valid = buildings_valid?
    procurement_buildings_valid = procurement_buildings_valid?
    procurement_building_services_valid = procurement_building_services_valid?

    [building_valid, procurement_buildings_valid, procurement_building_services_valid].all?
  end

  def buildings_valid?
    @procurement_array.all? { |building| building[:valid] }
  end

  def procurement_buildings_valid?
    @procurement_array.all? { |building| building[:procurement_building][:valid] }
  end

  def procurement_building_services_valid?
    @procurement_array.all? { |building| building[:procurement_building][:procurement_building_services].all? { |pbs| pbs[:valid] } }
  end

  # Save the entire import
  def save_spreadsheet_data
    delete_existing_procurement_buildings_and_services

    @procurement_array.each_with_index do |building, index|
      save_building(building[:object], index)
      building[:object].reload

      save_procurement_building(building)

      save_procurement_building_services(building)
    end

    @procurement.update(service_codes: service_codes)
  end

  def delete_existing_procurement_buildings_and_services
    @procurement.procurement_buildings.each(&:destroy)
  end

  def save_building(building, index)
    existing_building = @user.buildings.find_by(building_name: building.building_name)
    if existing_building.nil?
      building.save
    else
      if building.address_region.nil? && normalise_postcode(existing_building.address_postcode) == normalise_postcode(building.address_postcode)
        existing_building.assign_attributes(building.attributes.except('id', 'created_at', 'updated_at', 'address_region', 'address_region_code', 'building_json'))
      else
        existing_building.assign_attributes(building.attributes.except('id', 'created_at', 'updated_at', 'building_json'))
      end
      existing_building.save
      @procurement_array[index][:object] = existing_building
    end
  end

  def save_procurement_building(building)
    building[:procurement_building][:object].assign_attributes(building: building[:object])
    building[:procurement_building][:object].save

    building[:procurement_building][:object].reload
  end

  def save_procurement_building_services(building)
    procurement_building = building[:procurement_building][:object]
    building[:procurement_building][:procurement_building_services].each do |pbs|
      procurement_building_service = procurement_building.procurement_building_services.find_by(code: pbs[:object].code)

      procurement_building_service.assign_attributes(pbs[:object].attributes.slice('no_of_appliances_for_testing', 'no_of_building_occupants', 'no_of_consoles_to_be_serviced', 'tones_to_be_collected_and_removed', 'no_of_units_to_be_serviced', 'service_standard', 'lift_data', 'service_hours', 'detail_of_requirement'))
      procurement_building_service.save
      pbs[:object] = procurement_building_service
    end

    building[:procurement_building][:procurement_building_services].each { |pbs| pbs[:object].reload }
  end

  def normalise_postcode(postcode)
    postcode.gsub(' ', '').downcase
  end

  def service_codes
    @procurement_array.map { |building| building[:procurement_building][:object].service_codes }.flatten.uniq
  end
end
