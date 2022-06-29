module FacilitiesManagement
  module RM6232
    module Admin
      class SupplierData < ApplicationRecord
        belongs_to :upload, inverse_of: :supplier_data, foreign_key: :facilities_management_rm6232_admin_upload_id, optional: true
        has_many :edits, inverse_of: :supplier_data, class_name: 'FacilitiesManagement::RM6232::Admin::SupplierData::Edit', dependent: :destroy, foreign_key: :facilities_management_rm6232_admin_supplier_data_id

        def self.latest_data
          order(created_at: :desc).first
        end
      end
    end
  end
end
