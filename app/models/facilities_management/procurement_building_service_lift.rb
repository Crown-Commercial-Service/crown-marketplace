module FacilitiesManagement
  class ProcurementBuildingServiceLift < ApplicationRecord
    belongs_to :procurement_building_service, class_name: 'FacilitiesManagement::ProcurementBuildingService', foreign_key: :facilities_management_procurement_building_services_id, inverse_of: :lifts, optional: true

    validates :number_of_floors, numericality: { only_integer: true, greater_than: 0, less_than: 1000 }
  end
end
