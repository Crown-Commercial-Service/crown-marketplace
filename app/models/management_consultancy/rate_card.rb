module ManagementConsultancy
  class RateCard < ApplicationRecord
    belongs_to :supplier,
               foreign_key: :management_consultancy_supplier_id,
               inverse_of: :rate_cards
  end
end
