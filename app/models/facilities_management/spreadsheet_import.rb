module FacilitiesManagement
  class SpreadsheetImport < ApplicationRecord
    include AASM

    belongs_to :procurement, class_name: 'FacilitiesManagement::Procurement', foreign_key: :facilities_management_procurement_id, inverse_of: :spreadsheet_imports

    has_one_attached :spreadsheet_file
    validates :spreadsheet_file, attached: true
    validates :spreadsheet_file, content_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    validates :spreadsheet_file, size: { less_than: 10.megabytes }
    validates :spreadsheet_file, antivirus: true
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

    def spreadsheet_file_validation
      return unless spreadsheet_file.attached?

      errors[:base] << 'File extension must be .xlsx' unless spreadsheet_file.blob.filename.to_s.end_with?('.xlsx')
      spreadsheet_file.purge if errors.any?
    end
  end
end
