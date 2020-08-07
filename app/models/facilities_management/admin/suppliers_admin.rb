module FacilitiesManagement
  module Admin
    class SuppliersAdmin < ApplicationRecord
      self.table_name = 'fm_suppliers'

      def replace_services_for_lot(new_services, target_lot)
        data['lots'].each do |lot|
          if lot['lot_number'] == target_lot
            lot['services'] = new_services.nil? ? [] : new_services
            break
          end
        end
      end
    end
  end
end
