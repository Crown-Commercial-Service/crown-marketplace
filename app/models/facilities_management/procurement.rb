module FacilitiesManagement
  class Procurement < ApplicationRecord
    enum status: [:qs, :ds]

    belongs_to :user,
               foreign_key: :user_id,
               inverse_of: :procurements

    validates :name, presence: true
    validates :name, uniqueness: { scope: :user }
    validates :name, length: 1..100
  end
end
