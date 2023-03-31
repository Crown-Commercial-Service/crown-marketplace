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

        def true_change_type
          return change_type unless change_type == 'lot_data'

          data['attribute']
        end

        def short_id
          "##{id[..7]}"
        end

        # TODO: See if we can rmove this
        # rubocop:disable Metrics/AbcSize
        def current_supplier_data
          @current_supplier_data ||= begin
            supplier = supplier_data.data.find { |supplier_item| supplier_item['id'] == supplier_id }.dup

            supplier_data.edits.where(supplier_id:).where('created_at <= ?', created_at).order(created_at: :asc).each do |edit|
              if edit.change_type == 'lot_data'
                supplier_lot_data = supplier['lot_data'].find { |lot_data| lot_data['lot_code'] == edit.data['lot_code'] }

                lot_data_changes(edit, supplier_lot_data, 'removed', :delete)
                lot_data_changes(edit, supplier_lot_data, 'added', :push)
              else
                edit.data.each { |detail| supplier[detail['attribute']] = detail['value'] }
              end
            end

            supplier
          end
        end
        # rubocop:enable Metrics/AbcSize

        def lot_data_changes(edit, supplier_lot_data, key, method)
          edit.data[key].is_a?(Array) ? edit.data[key].each { |code| supplier_lot_data[edit.data['attribute']].send(method, code) } : supplier_lot_data[edit.data['attribute']] = edit.data[key]
        end

        def previous_supplier_data
          supplier_data.edits.where(supplier_id:).where('created_at < ?', created_at).order(created_at: :desc).first&.current_supplier_data || supplier_data.data.find { |supplier_item| supplier_item['id'] == supplier_id }
        end
      end
    end
  end
end
