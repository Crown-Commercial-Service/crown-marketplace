module FacilitiesManagement
  class Procurement < ApplicationRecord
    include AASM

    belongs_to :user,
               foreign_key: :user_id,
               inverse_of: :procurements

    validates :name, presence: true
    validates :name, uniqueness: { scope: :user }
    validates :name, length: 1..100

    aasm do
      state :quick_search, initial: true
      state :detailed_search

      event :start_detailed_search do
        transitions from: :quick_search, to: :detailed_search
      end
    end
  end
end
