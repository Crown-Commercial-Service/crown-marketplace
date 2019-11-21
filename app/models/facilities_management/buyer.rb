module FacilitiesManagement
  class Buyer < ApplicationRecord
    belongs_to :user, foreign_key: :user_id, inverse_of: :buyer
  end
end
