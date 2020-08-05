module FacilitiesManagement
  class SpreadsheetImport < ApplicationRecord
    include AASM

    belongs_to :procurement, class_name: 'FacilitiesManagement::Procurement', foreign_key: :facilities_management_procurement_id, inverse_of: :spreadsheet_imports

    TRANSLATION_SCOPE = %i[errors messages bulk_upload].freeze
    has_one_attached :spreadsheet_file
    validates :spreadsheet_file, attached: { message: I18n.t(:not_attached, scope: TRANSLATION_SCOPE)}
    validates :spreadsheet_file, antivirus: { message: I18n.t(:malicious, scope: TRANSLATION_SCOPE) }
    validates :spreadsheet_file, size: { less_than: 10.megabytes, message: I18n.t(:too_large, scope: TRANSLATION_SCOPE) }
    validates :spreadsheet_file, content_type: { with: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                                                 message: I18n.t(:wrong_content_type, scope: TRANSLATION_SCOPE) }
    validate :spreadsheet_file_ext_validation
    validate :spreadsheet_basic_data_validation

    aasm do
      state :importing, initial: true
      state :succeeded, :failed
      event :succeed do
        transitions from: :importing, to: :succeeded
      end
      event :fail do
        transitions from: :importing, to: :failed
        after do
          spreadsheet_file.purge
        end
      end
    end

    def spreadsheet_file_ext_validation
      return unless spreadsheet_file.attached?

      errors[:base] << I18n.t(:wrong_extension, scope: TRANSLATION_SCOPE) unless spreadsheet_file.blob.filename.to_s.end_with?('.xlsx')
    end

    def spreadsheet_basic_data_validation
      return if errors.any?

      FacilitiesManagement::SpreadsheetImporter.new(self).basic_data_validation.each do |error_message|
        errors[:base] << error_message
      end
    end
  end
end
