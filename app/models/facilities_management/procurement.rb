module FacilitiesManagement
  class Procurement < ApplicationRecord
    include ProcurementValidator

    belongs_to :user,
               foreign_key: :user_id,
               inverse_of: :procurements
  end
end
