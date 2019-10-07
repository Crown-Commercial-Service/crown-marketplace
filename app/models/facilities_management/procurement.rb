module FacilitiesManagement
  class Procurement < ApplicationRecord
    include AASM
    include ProcurementValidator

    belongs_to :user,
               foreign_key: :user_id,
               inverse_of: :procurements

    has_many :procurement_buildings, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement, dependent: :destroy
    accepts_nested_attributes_for :procurement_buildings, allow_destroy: true

    aasm do
      state :quick_search, initial: true
      state :detailed_search

      event :start_detailed_search do
        transitions from: :quick_search, to: :detailed_search
      end
    end
  end
end
