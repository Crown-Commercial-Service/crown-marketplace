module CCS
  module FM
    class RateCard < ApplicationRecord
      # Event.where("payload->>'kind' = ?", "user_renamed")

      # rubocop:disable Rails/FindBy
      def self.latest
        where(updated_at: CCS::FM::RateCard.select('max(updated_at)')).first
      end
      # rubocop:enable Rails/FindBy

      def self.building_types
        [
          :'General office - Customer Facing',
          :'General office - Non Customer Facing',
          :'Call Centre Operations',
          :Warehouses,
          :'Restaurant and Catering Facilities',
          :'Pre-School',
          :'Primary School',
          :'Secondary Schools',
          :'Special Schools',
          :'Universities and Colleges',
          :'Community - Doctors, Dentist, Health Clinic',
          :'Nursing and Care Homes'
        ]
      end
    end
  end
end
