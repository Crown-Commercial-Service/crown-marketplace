module FacilitiesManagement
  class Buildings < ApplicationRecord
    self.table_name = 'facilities_management_buildings'

    # CCS::FM::Building.all
    #
    def self.buildings_for_user(user_id)
      where("user_id = '" + Base64.encode64(user_id) + "'")
    end

    def self.building_by_reference(user_id, building_ref)
      find_by("user_id = '" + Base64.encode64(user_id) + "' and building_json->>'building-ref' = '#{building_ref}'")
    end
  end
end