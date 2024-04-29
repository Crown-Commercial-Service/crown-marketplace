module FacilitiesManagement::RM3830
  class SpreadsheetImporter
    POSTCODE_ROW = 6
    BUILDINGS_COMPLETE_ROW = 14
    # This can be added as more parts of the bulk upload are completed
    IMPORT_PROCESS_ORDER = %i[check_file process_file check_processed_data].freeze
    TEMPLATE_FILE_NAME = 'facilities-management/rm3830/Services and buildings template v1.0.xlsx'.freeze
    TEMPLATE_FILE_PATH = Rails.public_path.join(TEMPLATE_FILE_NAME).freeze

    def initialize(spreadsheet_import)
      @spreadsheet_import = spreadsheet_import
      @procurement = @spreadsheet_import.procurement
      @user = @procurement.user
      @user_uploaded_spreadsheet = Roo::Spreadsheet.open(downloaded_spreadsheet.path, extension: :xlsx)
      @errors = []
      @procurement_array = []
    end

    def import_data
      IMPORT_PROCESS_ORDER.each do |import_process|
        @spreadsheet_import.send("#{import_process}!")
        send(import_process)
        break if @errors.any?
      end

      @errors.any? ? process_invalid_import : process_valid_import
    rescue StandardError => e
      @spreadsheet_import.update(import_errors: { other_errors: { generic_error: 'generic error' } })
      @spreadsheet_import.fail_data_import!

      Rollbar.log('error', e)
    end

    private

    def process_valid_import
      @spreadsheet_import.save_data! unless spreadsheet_not_present?
      save_spreadsheet_data
      @spreadsheet_import.data_saved! unless spreadsheet_not_present?
    end

    def process_invalid_import
      @spreadsheet_import.update(import_errors: @errors) unless spreadsheet_not_present?
      @spreadsheet_import.fail_data_import! unless spreadsheet_not_present?
    end

    def spreadsheet_not_present?
      SpreadsheetImport.find_by(id: @spreadsheet_import.id).nil?
    end

    ########## Import processs ##########
    def check_file
      if !template_valid?
        @errors = { other_errors: { file_check_error: :template_invalid } }
      elsif spreadsheet_not_started?
        @errors = { other_errors: { file_check_error: :not_started } }
      elsif spreadsheet_not_ready?
        @errors = { other_errors: { file_check_error: :not_ready } }
      end
    end

    def process_file
      import_buildings
      add_procurement_buildings
      import_service_matrix
      import_service_volumes
      import_lift_data
      import_service_hours
      validate_procurement_building_services
    end

    def check_processed_data
      @errors = collect_errors unless imported_spreadsheet_data_valid?
    end

    ########## Checking the uploaded file ##########
    def spreadsheet_not_ready?
      instructions_sheet = @user_uploaded_spreadsheet.sheet(0)
      return true if instructions_sheet.row(10)[1] != 'Ready to upload'

      false
    end

    def spreadsheet_not_started?
      instructions_sheet = @user_uploaded_spreadsheet.sheet(0)
      instructions_sheet.row(10)[1] == 'Awaiting Data Input'
    end

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
        next if template_spreadsheet.sheet(tab).column(col).compact == @user_uploaded_spreadsheet.sheet(tab).column(col).compact

        return false
      end

      # Special case for list as has number of buildings at the end
      # return false if template_spreadsheet.sheet(8).column(3)[0..-2] != @user_uploaded_spreadsheet.sheet(8).column(3)[0..-2]

      true
    end

    ########## Importing buildings ##########
    def import_buildings
      building_sheet = @user_uploaded_spreadsheet.sheet('Building Information')

      if sheet_complete?(building_sheet, BUILDINGS_COMPLETE_ROW, 'Complete')
        building_columns(building_sheet).each_with_index do |col, index|
          index += 2
          if col.blank?
            @procurement_array << { skip: true }
          else
            building_column = building_sheet.column(index)
            building = @user.buildings.build(building_attribues(building_column))
            add_regions(building, building_column)
            store_building(building)
          end
        end
      else
        @errors << :building_incomplete
      end
    end

    def building_attribues(building_column)
      {
        building_name: building_column[1].to_s,
        description: building_column[2],
        address_line_1: building_column[3],
        address_line_2: building_column[4],
        address_town: building_column[5],
        address_postcode: building_column[POSTCODE_ROW].to_s&.upcase,
        gia: building_column[7],
        external_area: building_column[8],
        building_type: building_column[9],
        other_building_type: building_column[10],
        security_type: building_column[11],
        other_security_type: building_column[12]
      }
    end

    def add_regions(building, building_column)
      region = Postcode::PostcodeCheckerV2.find_region building_column[POSTCODE_ROW].to_s.delete(' ')
      (building.address_region_code = region[0][:code]) && (building.address_region = region[0][:region]) if region.count == 1
    end

    def store_building(building)
      validations = validate_building(building)
      @procurement_array << { object: building, valid: validations[0], errors: validations[1], skip: false }
    end

    def validate_building(building)
      building.valid?(:all)

      remove_expected_errors building

      building.errors.add(:building_name, :taken) unless @procurement_array.reject { |building_hash| building_hash[:skip] }.none? { |building_value| building_value[:object].building_name == building.building_name }

      [building.errors.empty?, building.errors.details.to_h]
    end

    def remove_expected_errors(building)
      building.errors.delete(:building_name) if error_present?(building.errors, :building_name, :taken)
      building.errors.delete(:address_region) if error_present?(building.errors, :address_region)
      building.errors.delete(:address_region_code) if error_present?(building.errors, :address_region_code)
    end

    def error_present?(errors, attribute, type = nil)
      if errors.include?(attribute)
        return true unless type

        errors.details[attribute.to_sym].pluck(:error).include? type
      else
        false
      end
    end

    def building_columns(sheet)
      columns = sheet.row(BUILDINGS_COMPLETE_ROW)[1..]
      index = columns.reverse.index { |x| x == 'Complete' } + 1

      columns[0..-index]
    end

    # Creating procurement buildings
    def add_procurement_buildings
      complete_procurement_array.each do |building|
        building[:procurement_building] = { object: ProcurementBuilding.new(procurement: @procurement, active: true), procurement_building_services: [] }
      end
    end

    ########## Importing procurement building services with service standard ##########
    SERVICE_CODES = %w[C.1a C.1b C.1c C.2a C.2b C.2c C.3a C.3b C.3c C.4a C.4b C.4c C.6a C.6b C.6c C.7a C.7b C.7c C.11a C.11b C.11c C.12a C.12b C.12c C.13a C.13b C.13c C.5a C.5b C.5c C.14a C.14b C.14c C.8 C.9 C.10 C.15 C.16 C.17 C.18 C.19 C.20 C.21 C.22 D.1 D.2 D.3 D.4 D.5 D.6 E.1 E.2 E.3 E.5 E.6 E.7 E.8 E.4 E.9 F.1 F.2 F.3 F.4 F.5 F.6 F.7 F.8 F.9 F.10 G.1a G.1b G.1c G.2 G.3a G.3b G.3c G.4a G.4b G.4c G.6 G.7 G.15 G.5a G.5b G.5c G.9 G.8 G.10 G.11 G.12 G.13 G.14 G.16 H.4 H.5 H.7 H.1 H.2 H.3 H.6 H.8 H.9 H.10 H.11 H.12 H.13 H.14 H.15 H.16 I.1 I.2 I.3 I.4 J.1 J.2 J.3 J.4 J.5 J.6 J.7 J.8 J.9 J.10 J.11 J.12 K.2 K.3 K.1 K.7 K.4 K.5 K.6 L.1 L.2 L.3 L.4 L.5 L.6 L.7 L.8 L.9 L.10 L.11 M.1 N.1 O.1].freeze

    def import_service_matrix
      matrix_sheet = @user_uploaded_spreadsheet.sheet('Service Matrix')
      spreadsheet_import_loop([matrix_sheet, 1, 'OK'], [matrix_sheet, 2, 1], 5, :service_matrix_incomplete) do |col, building_index|
        get_service_codes(matrix_sheet, col, building_index)
      end
    end

    def get_service_codes(matrix_sheet, col, index)
      matrix_column = matrix_sheet.column(col)[3..].map { |value| value == 'Yes' }
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
      procurement_building_service = ProcurementBuildingService.new(code:)
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

      procurement_building.valid?(:buildings_and_services)
      procurement_building.validate_spreadsheet_gia(building.gia, building.building_name)
      procurement_building.validate_spreadsheet_external_area(building.external_area, building.building_name)

      procurement_building_hash[:valid] = procurement_building.errors.empty?
      procurement_building_hash[:errors] = procurement_building.errors.details.to_h
    end

    ########## Importing Service volumes 1 ##########
    VOLUME_CODES = %w[E.4 G.1 G.3 K.1 K.2 K.3 K.4 K.5 K.6 K.7].freeze

    def import_service_volumes
      service_volume_sheet = @user_uploaded_spreadsheet.sheet('Service Volumes 1')
      spreadsheet_import_loop([service_volume_sheet, 1, 'OK'], [service_volume_sheet, 3, 4], 5, :volumes_incomplete) do |col, building_index|
        service_volume_column = service_volume_sheet.column(col)
        services = {}

        VOLUME_CODES.each_with_index do |code, index|
          services[code] = service_volume_column[index + 3]
        end

        add_service_volumes(services, building_index)
      end
    end

    def add_service_volumes(services, building_index)
      procurement_building_services = @procurement_array[building_index][:procurement_building][:procurement_building_services].pluck(:object)
      procurement_building_services.each do |pbs|
        next unless VOLUME_CODES.include?(pbs.code)

        volume = pbs.required_contexts[:volume].first
        pbs[volume] = services[pbs.code]
      end
    end

    ########## Importing Service volumes 2 ##########
    def import_lift_data
      service_volume_lifts_sheet = @user_uploaded_spreadsheet.sheet('Service Volumes 2')
      spreadsheet_import_loop([service_volume_lifts_sheet, 1, 'OK'], [service_volume_lifts_sheet, 2, 1], 6, :lifts_incomplete) do |col, building_index|
        procurement_building_service = @procurement_array[building_index][:procurement_building][:procurement_building_services].pluck(:object).find { |pbs| pbs.code == 'C.5' }
        next if procurement_building_service.nil?

        service_volume_column = service_volume_lifts_sheet.column(col)[6..45]

        next if missing_lifts?(service_volume_column, service_volume_lifts_sheet.column(col)[3])

        extract_lift_data(procurement_building_service, service_volume_column)
      end
    end

    def missing_lifts?(lifts, number_of_lifts)
      (NUMBER_OF_LIFTS - lifts.reverse.index(&:present?).to_i) != number_of_lifts || lifts.compact.count != number_of_lifts
    end

    NUMBER_OF_LIFTS = 40

    def extract_lift_data(procurement_building_service, service_volume_column)
      NUMBER_OF_LIFTS.times do |row|
        number_of_floors = service_volume_column[row]
        break if number_of_floors.nil?

        procurement_building_service.lifts.build(number_of_floors:)
      end
    end

    ########## Importing Service hours ##########
    SERVICE_HOUR_CODES = %w[H.4 H.5 I.1 I.2 I.3 I.4 J.1 J.2 J.3 J.4 J.5 J.6].freeze

    def import_service_hours
      service_hours_sheet = @user_uploaded_spreadsheet.sheet('Service Volumes 3')
      spreadsheet_import_loop([service_hours_sheet, 1, 'OK'], [service_hours_sheet, 3, 4], 5, :service_hours_incomplete) do |col, building_index|
        procurement_building_hash = @procurement_array[building_index][:procurement_building]
        procurement_building = procurement_building_hash[:object]
        next if skip_building?(procurement_building)

        procurement_building_services = procurement_building_hash[:procurement_building_services]
        service_hours = get_service_hours_from_sheet(service_hours_sheet, col)
        add_service_hour_data(procurement_building_services.pluck(:object), service_hours)
      end
    end

    def skip_building?(procurement_building)
      !procurement_building.service_codes.intersect?(SERVICE_HOUR_CODES)
    end

    def get_service_hours_from_sheet(sheet, col)
      service_hour_column = sheet.column(col)[3..]
      SERVICE_HOUR_CODES.map.with_index do |code, index|
        [code, { service_hours: service_hour_column[index * 2], detail_of_requirement: ActionController::Base.helpers.strip_tags(service_hour_column[(index * 2) + 1].to_s) }]
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

    ########## Validation of all the services once they have all been imported ##########
    def validate_procurement_building_services
      complete_procurement_array.each do |building|
        building[:procurement_building][:procurement_building_services].each do |procurement_building_service_hash|
          procurement_building_service = procurement_building_service_hash[:object]
          procurement_building_service.valid?(:all)

          procurement_building_service.errors.delete(:procurement_building)

          procurement_building_service_hash[:valid] = procurement_building_service.errors.empty?
          procurement_building_service_hash[:errors] = procurement_building_service.errors.details.to_h
        end
      end
    end

    ########## Methods to help with checking the spreadsheet before the import ##########
    def downloaded_spreadsheet
      tmpfile = Tempfile.create
      tmpfile.binmode
      tmpfile.write @spreadsheet_import.spreadsheet_file.download
      tmpfile.close
      tmpfile
    end

    ########## Shared methods ##########
    def sheet_complete?(sheet, row, message)
      status_indicator = sheet.row(row).compact.compact_blank
      status_indicator.shift
      status_indicator.count(message).positive? && status_indicator.reject { |status| status == message }.empty?
    end

    def sheet_contains_all_buildings?(sheet, row, shift_number)
      buildings = complete_procurement_array.map { |building| building[:object].building_name }
      sheet_buildings = sheet.row(row).compact.compact_blank
      sheet_buildings.shift(shift_number)
      (buildings.map(&:to_s).sort - sheet_buildings.map(&:to_s).map(&:squish).sort).empty?
    end

    def spreadsheet_import_loop(sheet_variables, building_variables, starting_column, error)
      if sheet_complete?(*sheet_variables) && sheet_contains_all_buildings?(*building_variables)
        (starting_column..@procurement_array.count + starting_column - 1).each_with_index do |col, building_index|
          next if @procurement_array[building_index][:skip]

          yield(col, building_index)
        end
      else
        @errors << error
      end
    end

    ########## Validate the entire import ##########
    def imported_spreadsheet_data_valid?
      building_valid = buildings_valid?
      procurement_buildings_valid = procurement_buildings_valid?
      procurement_building_services_valid = procurement_building_services_valid?

      [building_valid, procurement_buildings_valid, procurement_building_services_valid].all?
    end

    def buildings_valid?
      complete_procurement_array.all? { |building| building[:valid] }
    end

    def procurement_buildings_valid?
      complete_procurement_array.all? { |building| building[:procurement_building][:valid] }
    end

    def procurement_building_services_valid?
      complete_procurement_array.all? { |building| building[:procurement_building][:procurement_building_services].all? { |pbs| pbs[:valid] } }
    end

    ########## Collect errors to show to the user ##########
    def collect_errors
      @procurement_array.map.with_index(1) do |building, index|
        [:"Building #{index}",
         if building[:skip]
           {
             skip: true
           }
         else
           {
             skip: false,
             building_name: building[:object].building_name || "Building #{index}",
             building_errors: building[:errors],
             procurement_building_errors: building[:procurement_building][:errors],
             procurement_building_services_errors: building[:procurement_building][:procurement_building_services].to_h { |pbs| [pbs[:object].code.to_sym, pbs[:errors]] }
           }
         end]
      end.compact.to_h
    end

    ########## Save the entire import ##########
    def save_spreadsheet_data
      delete_existing_procurement_buildings_and_services

      complete_procurement_array.each do |building|
        save_building(building)

        save_procurement_building(building)

        save_procurement_building_services(building)
      end

      @procurement.update(service_codes:)
    end

    def delete_existing_procurement_buildings_and_services
      @procurement.procurement_buildings.where.not(id: nil).find_each(&:destroy)
    end

    def save_building(building_hash)
      building = building_hash[:object]

      existing_building = @user.buildings.find_by(building_name: building.building_name)
      if existing_building.nil?
        building.save
      else
        if building.address_region.nil? && normalise_postcode(existing_building.address_postcode) == normalise_postcode(building.address_postcode)
          existing_building.assign_attributes(building.attributes.except('id', 'created_at', 'updated_at', 'address_region', 'address_region_code'))
        else
          existing_building.assign_attributes(building.attributes.except('id', 'created_at', 'updated_at'))
        end
        existing_building.save
        building_hash[:object] = existing_building
      end

      building_hash[:object].reload
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

        procurement_building_service.assign_attributes(pbs[:object].attributes.slice('no_of_appliances_for_testing', 'no_of_building_occupants', 'no_of_consoles_to_be_serviced', 'tones_to_be_collected_and_removed', 'no_of_units_to_be_serviced', 'service_standard', 'service_hours', 'detail_of_requirement'))
        save_lift_data(procurement_building_service, pbs[:object]) if procurement_building_service.code == 'C.5'
        procurement_building_service.save
        pbs[:object] = procurement_building_service
        pbs[:object].reload
      end
    end

    def save_lift_data(procurement_building_service, object)
      object.lift_data.each do |number_of_floors|
        procurement_building_service.lifts.create(number_of_floors:)
      end
    end

    def normalise_postcode(postcode)
      postcode.gsub(' ', '').upcase
    end

    def service_codes
      complete_procurement_array.map { |building| building[:procurement_building][:object].service_codes }.flatten.uniq
    end

    # An array of all the procurement buildings that are complete
    def complete_procurement_array
      @complete_procurement_array ||= @procurement_array.reject { |building| building[:skip] }
    end
  end
end
