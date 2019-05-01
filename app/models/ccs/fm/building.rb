module CCS
  module FM
    def self.table_name_prefix
      'facilities_management_'
    end

    # -----------------
    # facilities_management_buildings
    class Building < ApplicationRecord
      # CCS::FM::Building.all
      # CCS::FM::Building.buildings_for_user('cognito@example.com')
      # 'Y29nbml0b0BleGFtcGxlLmNvbQ=='
      def self.buildings_for_user(user_id)
        CCS::FM::Building.all.where("user_id = '" + Base64.encode64(user_id) + "'")
      end
    end
  end
end
