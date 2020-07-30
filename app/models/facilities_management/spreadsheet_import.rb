module FacilitiesManagement
  class SpreadsheetImport < ApplicationRecord
    include AASM

    belongs_to :procurement, class_name: 'FacilitiesManagement::Procurement', foreign_key: :facilities_management_procurement_id, inverse_of: :spreadsheet_imports

    has_one_attached :spreadsheet_file

    aasm do
      state :in_progress, initial: true
      state :succeeded, :failed
      event :finish_import do
        transitions from: :in_progress, to: :succeeded
      end
    end
  end
end
