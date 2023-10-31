module FacilitiesManagement
  module RM3830
    class Procurement::CallOffExtension < ApplicationRecord
      include CallOffExtensionConcern

      self.table_name = 'facilities_management_rm3830_procurement_extensions'

      belongs_to :procurement, foreign_key: :facilities_management_rm3830_procurement_id, inverse_of: :call_off_extensions
    end
  end
end
