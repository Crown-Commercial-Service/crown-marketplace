module FacilitiesManagement
  class Buildings < ApplicationRecord
    self.table_name = 'facilities_management_buildings'
    self.primary_key = 'id'

    STANDARD_BUILDING_TYPES = ['General office - Customer Facing', 'General office - Non Customer Facing', 'Call Centre Operations',
                               'Warehouses', 'Restaurant and Catering Facilities', 'Pre-School', 'Primary School', 'Secondary School', 'Special Schools',
                               'Universities and Colleges', 'Doctors, Dentists and Health Clinics', 'Nursery and Care Homes'].freeze

    # CCS::FM::Building.all
    #
    def self.buildings_for_user(user_id)
      where("user_id = '" + Base64.encode64(user_id) + "'")
    end

    def self.building_by_reference(user_id, building_ref)
      find_by("user_id = '" + Base64.encode64(user_id) + "' and building_json->>'building-ref' = '#{building_ref}'")
    end

    def building_standard
      STANDARD_BUILDING_TYPES.include?(building_json['building-type']) ? 'STANDARD' : 'NON-STANDARD'
    end
  end
end
