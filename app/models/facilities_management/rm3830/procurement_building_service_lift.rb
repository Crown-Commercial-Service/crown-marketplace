module FacilitiesManagement
  module RM3830
    class ProcurementBuildingServiceLift < ApplicationRecord
      self.table_name = 'facilities_management_procurement_building_service_lifts'

      belongs_to :procurement_building_service, class_name: 'FacilitiesManagement::RM3830::ProcurementBuildingService', foreign_key: :facilities_management_rm3830_procurement_building_service_id, inverse_of: :lifts, optional: true

      validates :number_of_floors, numericality: { only_integer: true, greater_than: 0, less_than: 1000 }
    end
  end
end
