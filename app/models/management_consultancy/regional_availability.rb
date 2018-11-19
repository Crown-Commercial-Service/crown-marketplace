module ManagementConsultancy
  class RegionalAvailability < ApplicationRecord
    belongs_to :supplier,
               foreign_key: :management_consultancy_supplier_id,
               inverse_of: :regional_availabilities

    validates :lot_number, presence: true
    validates :region_code, presence: true
  end
end
