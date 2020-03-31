module FacilitiesManagement
  class ExpiredBuildings < ApplicationRecord
    self.table_name = 'facilities_management_buildings'
    self.primary_key = 'id'

    validates :building_name, presence: true, on: %i[building_name all]
    validates :gia, presence: true, on: %i[gia all]
    validates :security_type, presence: true, on: %i[security_type all]
    validates :building_type, presence: true, on: %i[building_type all]
    validates :building_ref, presence: true, on: %i[address all]
    validates :region, presence: true, on: %i[address all]
    validates :address_region_code, presence: true, on: %i[address all]
    validates :address_postcode, presence: true, on: %i[address all]

    # CCS::FM::Building.all
    #
    def self.buildings_for_user(user_id)
      where("user_email = '" + Base64.encode64(user_id) + "'")
    end

    def self.building_by_reference(user_id, building_ref)
      find_by("user_email = '" + Base64.encode64(user_id) + "' and building_json->>'building-ref' = '#{building_ref}'")
    end
  end
end
