module CCS
  module FM
    # -----------------
    # facilities_management_buildings
    class Building < ApplicationRecord
      self.table_name = 'facilities_management_buildings'

      STANDARD_BUILDING_TYPES = ['General office - Customer Facing', 'General office - Non Customer Facing', 'Call Centre Operations',
                                 'Warehouses', 'Restaurant and Catering Facilities', 'Pre-School', 'Primary School', 'Secondary School', 'Special Schools',
                                 'Universities and Colleges', 'Doctors, Dentists and Health Clinics', 'Nursery and Care Homes'].freeze

      # CCS::FM::Building.all
      #
      def self.buildings_for_user(user_id)
        where("user_id = '" + Base64.encode64(user_id) + "'")
      end

      def building_standard
        STANDARD_BUILDING_TYPES.include?(building_json['building-type']) ? 'STANDARD' : 'NON-STANDARD'
      end
    end
  end
end
