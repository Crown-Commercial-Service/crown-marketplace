module FacilitiesManagement
  class Buyer < ApplicationRecord
    belongs_to :user, inverse_of: :buyer
  end
end
