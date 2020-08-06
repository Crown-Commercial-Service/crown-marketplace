module FacilitiesManagement
  class SpreadsheetImport < ApplicationRecord
    include AASM

    belongs_to :procurement, class_name: 'FacilitiesManagement::Procurement',
                             foreign_key: :facilities_management_procurement_id, inverse_of: :spreadsheet_imports

    has_one_attached :spreadsheet_file
    validates :spreadsheet_file, attached: { message: :not_attached }
    validates :spreadsheet_file, antivirus: { message: :malicious }
    validates :spreadsheet_file, size: { less_than: 10.megabytes, message: :too_large }
    validates :spreadsheet_file, content_type: { with: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                                                 message: :wrong_content_type }
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

      errors.add(:spreadsheet_file, :wrong_extension) unless spreadsheet_file.blob.filename.to_s.end_with?('.xlsx')
    end

    def spreadsheet_basic_data_validation
      return if errors.any?

      FacilitiesManagement::SpreadsheetImporter.new(self).basic_data_validation.each do |error_symbol|
        errors.add(:spreadsheet_file, error_symbol)
      end
    end
  end
end
