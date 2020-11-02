module FacilitiesManagement
  module Admin
    class SuppliersAdmin < ApplicationRecord
      self.table_name = 'fm_suppliers'

      def replace_services_for_lot(new_services, target_lot)
        lot_data[target_lot]['services'] = new_services || []
      end
    end
  end
end
