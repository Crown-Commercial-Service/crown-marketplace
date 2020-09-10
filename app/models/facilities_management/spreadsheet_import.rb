module FacilitiesManagement
  class SpreadsheetImport < ApplicationRecord
    include AASM

    belongs_to :procurement, class_name: 'FacilitiesManagement::Procurement',
                             foreign_key: :facilities_management_procurement_id, inverse_of: :spreadsheet_import

    has_one_attached :spreadsheet_file
    validate :spreadsheet_file_attached, on: :upload # the 'attached' macro ignores custom error messages hence this validator
    validate :spreadsheet_file_ext_validation, on: :upload
    validates :spreadsheet_file, antivirus: { message: :malicious }, on: :upload
    # validates :spreadsheet_file, size: { less_than: 10.megabytes, message: :too_large }, on: :upload
    # validates :spreadsheet_file, content_type: { with: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    #                                             message: :wrong_content_type }, on: :upload
    # validate :spreadsheet_basic_data_validation, on: :upload

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
        transitions from: :importing, to: :succeeded
      end

      event :fail do
        transitions from: :importing, to: :failed
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
  end
end
