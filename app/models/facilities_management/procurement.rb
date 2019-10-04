module FacilitiesManagement
  class Procurement < ApplicationRecord
    include AASM
    include ProcurementValidator

    belongs_to :user,
               foreign_key: :user_id,
               inverse_of: :procurements

    aasm do
      state :quick_search, initial: true
      state :detailed_search

      event :start_detailed_search do
        transitions from: :quick_search, to: :detailed_search
      end
    end
  end
end
