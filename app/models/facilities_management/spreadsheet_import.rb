module FacilitiesManagement
  class SpreadsheetImport < ApplicationRecord
    include AASM

    belongs_to :procurement, class_name: 'FacilitiesManagement::Procurement',
                             foreign_key: :facilities_management_procurement_id, inverse_of: :spreadsheet_import

    has_one_attached :spreadsheet_file
    validate :spreadsheet_file_attached, on: :upload # the 'attached' macro ignores custom error messages hence this validator
    validate :spreadsheet_file_ext_validation, on: :upload
    validates :spreadsheet_file, antivirus: { message: :malicious }, on: :upload
    validates :spreadsheet_file, size: { less_than: 10.megabytes, message: :too_large }, on: :upload
    validates :spreadsheet_file, content_type: { with: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', message: :wrong_content_type }, on: :upload

    serialize :import_errors

    aasm do
      state :upload, initial: true
      state :importing, :succeeded, :failed
      event :start_import do
        transitions from: :upload, to: :importing
        after do
          FacilitiesManagement::UploadSpreadsheetWorker.perform_async(id)
        end
      end

      event :succeed do
        transitions from: %i[upload importing], to: :succeeded
      end

      event :fail do
        transitions from: %i[upload importing], to: :failed
        after do
          remove_spreadsheet_file
        end
      end
    end

    def remove_spreadsheet_file
      spreadsheet_file.purge
    end

    def spreadsheet_file_attached
      errors.add(:spreadsheet_file, :not_attached) unless spreadsheet_file.attached?
    end

    def spreadsheet_file_ext_validation
      return unless spreadsheet_file.attached?

      errors.add(:spreadsheet_file, :wrong_extension) unless spreadsheet_file.blob.filename.to_s.end_with?('.xlsx')
    end

    def spreadsheet_basic_data_validation
      return if errors.any?

      FacilitiesManagement::SpreadsheetImporter.new(self).basic_data_validation.each do |error_symbol|
        errors.add(:spreadsheet_file, error_symbol)
      end
    end

    def state_to_string
      case aasm_state
      when 'importing'
        [:grey, 'Upload in progress']
      when 'succeeded'
        [:blue, 'Upload completed']
      when 'failed'
        [:red, 'Upload failed']
      end
    end

    BUILDING_ATTRIBUTES = %i[building_name description address_line_1 address_line_2 address_town address_postcode gia external_area building_type other_building_type security_type other_security_type].freeze
    SERVICE_MATRIX_ATTRIBUTES = %i[service_codes building].freeze

    def building_errors
      (1..errors_from_import.count).map do |index|
        BUILDING_ATTRIBUTES.map do |attribute|
          building_error(index, attribute)
        end.compact
      end.flatten(1)
    end

    def service_matrix_errors
      (1..errors_from_import.count).map do |index|
        SERVICE_MATRIX_ATTRIBUTES.map do |attribute|
          service_matrix_error(index, attribute)
        end.compact
      end.flatten(1)
    end

    def service_volume_errors
      (1..errors_from_import.count).map do |index|
        service_volume_codes_with_attributes.map do |code, attribute|
          service_error(index, code, attribute, false)
        end.compact
      end.flatten(1)
    end

    def lift_errors
      (1..errors_from_import.count).map do |index|
        lift_error(index)
      end.compact
    end

    def service_hour_errors
      (1..errors_from_import.count).map do |index|
        service_hour_codes_with_attributes.map do |code, attributes|
          attributes.map { |attribute| service_error(index, code, attribute) }.compact
        end.compact.flatten(1)
      end.flatten(1)
    end

    private

    def building_error(building_index, attribute)
      error_details = error_detail(building_index, :building_errors, attribute)

      return unless error_details

      error_hash("Building #{building_index}", nil, attribute, error_types(error_details))
    end

    def service_matrix_error(building_index, attribute)
      error_details = error_detail(building_index, :procurement_building_errors, attribute)

      return unless error_details

      error_hash(error_building_name(building_index), nil, attribute, error_types(error_details))
    end

    def service_error(building_index, code, attribute, error_required = true)
      error_details = service_error_detail(building_index, code)

      return unless error_details && error_details[attribute]

      error_list = error_required ? error_types(error_details[attribute]) : nil

      error_hash(error_building_name(building_index), service_name(code), attribute, error_list)
    end

    def lift_error(building_index)
      error_details = service_error_detail(building_index, 'C.5')

      return unless error_details&.any?

      if error_details.key?(:lifts)
        error_hash(error_building_name(building_index), service_name('C.5'), :lifts, nil)
      else
        error_hash(error_building_name(building_index), service_name('C.5'), :number_of_floors, nil)
      end
    end

    def error_hash(building_name, service_name, attribute, errors)
      { building_name: building_name, service_name: service_name, attribute: attribute, errors: errors }.compact
    end

    def errors_from_import
      @errors_from_import ||= import_errors
    end

    def error_building_name(building_index)
      errors_from_import[:"Building #{building_index}"][:building_name]
    end

    def error_detail(building_index, model, attribute)
      errors_from_import[:"Building #{building_index}"][model][attribute]
    end

    def service_error_detail(building_index, code)
      errors_from_import[:"Building #{building_index}"][:procurement_building_services_errors][code.to_sym]
    end

    def error_types(error_details)
      error_details.map { |e| e[:error] }.uniq
    end

    def service_name(code)
      work_packages ||= FacilitiesManagement::StaticData.work_packages

      work_packages.find { |wp| wp['code'] == code }['name']
    end

    def service_volume_codes_with_attributes
      FacilitiesManagement::ServicesAndQuestions.get_codes_by_context(:volume).map do |code|
        [code, FacilitiesManagement::ServicesAndQuestions.service_detail(code)[:context][:volume].first]
      end.to_h
    end

    def service_hour_codes_with_attributes
      FacilitiesManagement::ServicesAndQuestions.get_codes_by_context(:service_hours).map do |code|
        [code, %i[service_hours detail_of_requirement]]
      end.to_h
    end
  end
end
