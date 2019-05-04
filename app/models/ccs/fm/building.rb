module CCS
  module FM
    def self.table_name_prefix
      'facilities_management_'
    end

    # -----------------
    # facilities_management_buildings
    class Building < ApplicationRecord
      self.table_name = 'facilities_management_buildings'

      # CCS::FM::Building.all
      #
      def self.buildings_for_user(user_id)
        CCS::FM::Building.all.where("user_id = '" + Base64.encode64(user_id) + "'")
      end

    end
  end
end
