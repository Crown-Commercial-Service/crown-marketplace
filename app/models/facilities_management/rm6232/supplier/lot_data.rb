module FacilitiesManagement
  module RM6232
    class Supplier::LotData < ApplicationRecord
      belongs_to :supplier, inverse_of: :lot_data, foreign_key: :facilities_management_rm6232_supplier_id

      delegate :supplier_name, to: :supplier

      validates :region_codes, length: { minimum: 1 }, on: :region_codes
      validates :active, inclusion: { in: [true, false] }, on: :lot_status

      def services
        Service.where(code: service_codes)
      end

      def regions
        Region.where(code: region_codes)
      end

      def current_status
        if active
          ['ACTIVE']
        else
          ['INACTIVE', :red]
        end
      end

      def changed_data
        model_changes = saved_changes.except(:updated_at).first
        data_before = model_changes.last.first
        data_after = model_changes.last.last

        added = data_after.is_a?(Array) ? data_after - data_before : data_after
        removed = data_before.is_a?(Array) ? data_before - data_after : data_before

        [
          supplier.id,
          :lot_data,
          {
            attribute: model_changes.first,
            lot_code: lot_code,
            added: added,
            removed: removed
          }
        ]
      end
    end
  end
end
