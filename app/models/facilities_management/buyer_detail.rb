module FacilitiesManagement
  class BuyerDetail < ApplicationRecord
    belongs_to :user, foreign_key: :user_id, inverse_of: :buyer_detail
  end
end
