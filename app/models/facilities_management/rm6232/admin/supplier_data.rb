module FacilitiesManagement
  module RM6232
    module Admin
      class SupplierData < ApplicationRecord
        belongs_to :upload, inverse_of: :supplier_data, foreign_key: :facilities_management_rm6232_admin_upload_id, optional: true
        has_many :edits, inverse_of: :supplier_data, class_name: 'FacilitiesManagement::RM6232::Admin::SupplierData::Edit', dependent: :destroy, foreign_key: :facilities_management_rm6232_admin_supplier_data_id

        def self.latest_data
          order(created_at: :desc).first
        end

        def self.audit_logs
          order(created_at: :desc).map do |supplier_data|
            [
              supplier_data.edits.order(created_at: :desc).map do |edit|
                {
                  id: edit.id,
                  short_id: edit.short_id,
                  created_at: edit.created_at,
                  user_email: edit.user.email,
                  change_type: edit.change_type,
                  true_change_type: edit.true_change_type
                }
              end,
              {
                id: supplier_data.id,
                short_id: supplier_data.short_id,
                created_at: supplier_data.created_at,
                user_email: supplier_data.upload&.user&.email,
                change_type: 'upload',
                true_change_type: 'upload'
              }
            ]
          end.flatten
        end

        def true_change_type
          'upload'
        end

        def short_id
          "##{id[..7]}"
        end
      end
    end
  end
end
