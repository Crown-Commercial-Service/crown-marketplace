module FacilitiesManagement
  class SpreadsheetImport < ApplicationRecord
    include AASM

    belongs_to :procurement, class_name: 'FacilitiesManagement::Procurement', foreign_key: :facilities_management_procurement_id, inverse_of: :spreadsheet_imports

    has_one_attached :spreadsheet_file
    validate :spreadsheet_file_validation

    aasm do
      state :importing, initial: true
      state :succeeded, :failed
      event :succeed do
        transitions from: :importing, to: :succeeded
      end
      event :fail do
        transitions from: :importing, to: :failed
      end
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    def spreadsheet_file_validation
      return unless spreadsheet_file.attached?

      errors[:base] << 'Too small' if spreadsheet_file.blob.byte_size < 1.megabyte
      errors[:base] << 'Too big' if spreadsheet_file.blob.byte_size > 5.megabytes
      errors[:base] << 'Wrong ext' unless spreadsheet_file.blob.filename.to_s.end_with?('.xlsx')
      errors[:base] << 'Wrong format' unless spreadsheet_file.blob.content_type == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'

      spreadsheet_file.purge if errors.any?
    end
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/AbcSize
  end
end
