module FacilitiesManagement
  class SpreadsheetImport < ApplicationRecord
    belongs_to :procurement, class_name: 'FacilitiesManagement::Procurement', foreign_key: :facilities_management_procurement_id, inverse_of: :spreadsheet_imports

    has_one_attached :spreadsheet_file
  end
end
