module FacilitiesManagement
  module RM6232
    class Supplier::LotData < ApplicationRecord
      belongs_to :supplier, inverse_of: :lot_data, foreign_key: :facilities_management_rm6232_supplier_id

      delegate :supplier_name, to: :supplier

      validates :region_codes, length: { minimum: 1 }, on: :region_codes

      def services
        Service.where(code: service_codes)
      end

      def regions
        Region.where(code: region_codes)
      end

      def changed_data
        model_changes = saved_changes.except(:updated_at).first
        data_before = model_changes.last.first
        data_after = model_changes.last.last

        [
          supplier.id,
          :lot_data,
          {
            attribute: model_changes.first,
            lot_code: lot_code,
            added: data_after - data_before,
            removed: data_before - data_after
          }
        ]
      end
    end
  end
end
