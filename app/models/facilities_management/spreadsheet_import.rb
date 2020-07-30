module FacilitiesManagement
  class SpreadsheetImport < ApplicationRecord
    include AASM

    belongs_to :procurement, class_name: 'FacilitiesManagement::Procurement', foreign_key: :facilities_management_procurement_id, inverse_of: :spreadsheet_imports

    mount_uploader :spreadsheet_file, SpreadsheetFileUploader

    aasm do
      state :in_progress, initial: true
      state :succeeded, :failed
      event :succeed do
        transitions from: :in_progress, to: :succeeded
      end
      event :fail do
        transitions from: :in_progress, to: :failed
      end
    end
  end
end
