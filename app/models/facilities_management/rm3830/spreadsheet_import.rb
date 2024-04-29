module FacilitiesManagement
  module RM3830
    class SpreadsheetImport < ApplicationRecord
      include AASM

      belongs_to :procurement, class_name: 'FacilitiesManagement::RM3830::Procurement',
                               foreign_key: :facilities_management_rm3830_procurement_id, inverse_of: :spreadsheet_import

      has_one_attached :spreadsheet_file
      validate :spreadsheet_file_attached, on: :upload # the 'attached' macro ignores custom error messages hence this validator
      validate :spreadsheet_file_ext_validation, on: :upload
      validates :spreadsheet_file, antivirus: { message: :malicious }, on: :upload
      validates :spreadsheet_file, size: { less_than: 10.megabytes, message: :too_large }, on: :upload
      validates :spreadsheet_file, content_type: { with: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', message: :wrong_content_type }, on: :upload

      aasm do
        state :upload, initial: true
        state :importing, :succeeded, :failed
        event :start_import do
          transitions from: :upload, to: :importing
          after do
            start_upload!
          end
        end

        event :succeed do
          transitions from: %i[upload importing], to: :succeeded
        end

        event :fail do
          transitions from: %i[upload importing], to: :failed
        end
      end

      aasm(:data_import, column: 'data_import_state') do
        state :not_started, initial: true
        state :in_progress, :checking_file, :processing_file, :checking_processed_data, :saving_data, :data_import_succeed, :data_import_failed
        event :start_upload, after_commit: -> { UploadSpreadsheetWorker.perform_async(id) } do
          transitions from: :not_started, to: :in_progress
        end
        event :check_file do
          transitions from: :in_progress, to: :checking_file
        end
        event :process_file do
          transitions from: :checking_file, to: :processing_file
        end
        event :check_processed_data do
          transitions from: :processing_file, to: :checking_processed_data
        end
        event :save_data do
          transitions from: :checking_processed_data, to: :saving_data
        end
        event :data_saved do
          transitions from: :saving_data, to: :data_import_succeed
          after do
            succeed!
          end
        end
        event :fail_data_import do
          transitions from: %i[not_started in_progress checking_file processing_file checking_processed_data saving_data data_import_succeed], to: :data_import_failed
          after do
            fail!
          end
        end
      end

      def remove_spreadsheet_file
        spreadsheet_file.purge
      end

      def state_to_string
        STATES_TO_STRINGS[aasm_state.to_sym]
      end

      STATES_TO_STRINGS = { importing: ['Upload in progress', :grey], succeeded: ['Upload completed'], failed: ['Upload failed', :red] }.freeze
      BUILDING_ATTRIBUTES = %i[building_name description address_line_1 address_line_2 address_town address_postcode gia external_area building_type other_building_type security_type other_security_type].freeze
      SERVICE_MATRIX_ATTRIBUTES = %i[service_codes building].freeze

      def building_errors
        error_loop do |index|
          BUILDING_ATTRIBUTES.map do |attribute|
            building_error(index, attribute)
          end.compact
        end
      end

      def service_matrix_errors
        error_loop do |index|
          SERVICE_MATRIX_ATTRIBUTES.map do |attribute|
            service_matrix_error(index, attribute)
          end.compact
        end
      end

      def service_volume_errors
        error_loop do |index|
          service_volume_codes_with_attributes.map do |code, attribute|
            service_error(index, code, attribute, true)
          end.compact
        end
      end

      def lift_errors
        (1..errors_from_import.count).map do |index|
          next if skip_building?(index)

          lift_error(index)
        end.compact
      end

      def service_hour_errors
        error_loop do |index|
          service_hour_codes_with_attributes.map do |code, attributes|
            attributes.map { |attribute| service_error(index, code, attribute) }.compact
          end.compact.flatten(1)
        end
      end

      private

      def error_loop
        (1..errors_from_import.count).map do |index|
          next if skip_building?(index)

          yield(index)
        end.compact.flatten(1)
      end

      def skip_building?(index)
        errors_from_import[:"Building #{index}"][:skip]
      end

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

      def service_error(building_index, code, attribute, volume_error = false)
        error_details = service_error_detail(building_index, code)

        return unless error_details && error_details[attribute]

        error_list = volume_error ? [volume_error(error_types(error_details[attribute]))] : error_types(error_details[attribute])

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
        { building_name:, service_name:, attribute:, errors: }.compact
      end

      def errors_from_import
        @errors_from_import ||= import_errors.deep_symbolize_keys
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
        error_details.pluck(:error).uniq
      end

      def volume_error(error_list)
        error_list.include?('blank') ? 'blank' : 'invalid'
      end

      def service_name(code)
        work_packages ||= StaticData.work_packages

        work_packages.find { |wp| wp['code'] == code }['name']
      end

      def service_volume_codes_with_attributes
        ServicesAndQuestions.get_codes_by_context(:volume).index_with do |code|
          ServicesAndQuestions.service_detail(code)[:context][:volume].first
        end
      end

      def service_hour_codes_with_attributes
        ServicesAndQuestions.get_codes_by_context(:service_hours).index_with do |_code|
          %i[service_hours detail_of_requirement]
        end
      end

      def spreadsheet_file_attached
        errors.add(:spreadsheet_file, :not_attached) unless spreadsheet_file.attached?
      end

      def spreadsheet_file_ext_validation
        return unless spreadsheet_file.attached?

        errors.add(:spreadsheet_file, :wrong_extension) unless spreadsheet_file.blob.filename.to_s.end_with?('.xlsx')
      end
    end
  end
end
