module FacilitiesManagement
  module RM6232
    module Admin
      class SupplierData::Edit < ApplicationRecord
        self.table_name = 'facilities_management_rm6232_admin_supplier_data_edits'

        belongs_to :supplier_data, inverse_of: :edits, foreign_key: :facilities_management_rm6232_admin_supplier_data_id
        belongs_to :user, inverse_of: :rm6232_supplier_data_edits

        def self.log_change(user, model)
          return if model.saved_changes.blank?

          create!(user: user, supplier_data: SupplierData.latest_data, **%i[supplier_id change_type data].zip(model.changed_data).to_h)
        end
      end
    end
  end
end
