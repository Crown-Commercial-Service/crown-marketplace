module CCS
  module FM
    # -----------------
    # facilities_management_buildings
    class UnitOfMeasurementValues < ApplicationRecord
      # self.table_name = 'fm_lifts'
      def self.table_name
        'fm_uom_values'
      end

      # CCS::FM::UnitOfMeasurementValues.all
      #
      def self.values_for_user(user_id)
        where("user_id = '" + Base64.encode64(user_id) + "'")
      end
    end
  end
end
