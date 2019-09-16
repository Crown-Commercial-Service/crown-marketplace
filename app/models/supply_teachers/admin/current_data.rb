module SupplyTeachers
  module Admin
    class CurrentData < ApplicationRecord
      self.table_name = 'supply_teachers_admin_current_data'

      ATTRIBUTES = %i[current_accredited_suppliers geographical_data_all_suppliers lot_1_and_lot_2_comparisons master_vendor_contacts neutral_vendor_contacts pricing_for_tool supplier_lookup].freeze

      # input files
      mount_uploader :current_accredited_suppliers, SupplyTeachersFileUploader
      mount_uploader :geographical_data_all_suppliers, SupplyTeachersFileUploader
      mount_uploader :lot_1_and_lot_2_comparisons, SupplyTeachersFileUploader
      mount_uploader :master_vendor_contacts, SupplyTeachersFileUploader
      mount_uploader :neutral_vendor_contacts, SupplyTeachersFileUploader
      mount_uploader :pricing_for_tool, SupplyTeachersFileUploader
      mount_uploader :supplier_lookup, SupplyTeachersFileUploader

      # output file
      mount_uploader :data, SupplyTeachersJsonFileUploader
    end
  end
end
