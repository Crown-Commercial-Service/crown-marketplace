class FacilitiesManagementRegionalAvailability < ApplicationRecord
  LOT_NUMBERS = {
    '1a' => 'Total contract value up to £7M',
    '1b' => 'Total contract value £7M - £50M',
    '1c' => 'Total contract value over £50M'
  }.freeze

  belongs_to :supplier,
             class_name: 'FacilitiesManagementSupplier',
             foreign_key: :facilities_management_supplier_id,
             inverse_of: :regional_availabilities

  validates :lot_number, presence: true
  validates :region_code, presence: true
end
