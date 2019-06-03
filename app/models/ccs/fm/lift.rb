module CCS
  module FM
    # -----------------
    # facilities_management_buildings
    class Lift < ApplicationRecord
      # self.table_name = 'fm_lifts'
      def self.table_name_prefix
        'fm_'
      end

      # CCS::FM::Lift.all
      #
      def self.lifts_for_user(user_id)
        where("user_id = '" + Base64.encode64(user_id) + "'")
      end
    end
  end
end
