module FacilitiesManagement
  module RM6232
    class ProcurementBuilding < ApplicationRecord
      scope :active, -> { where(active: true) }
      scope :order_by_building_name, -> { joins(:building).merge(FacilitiesManagement::Building.order(FacilitiesManagement::Building.arel_table['building_name'].lower.asc)) }

      belongs_to :procurement, foreign_key: :facilities_management_rm6232_procurement_id, inverse_of: :procurement_buildings
      belongs_to :building, class_name: 'FacilitiesManagement::Building'

      delegate :building_name, to: :building
      delegate :address_no_region, to: :building
    end
  end
end
