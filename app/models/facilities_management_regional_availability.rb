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

  def self.for_lot(lot_number)
    where(lot_number: lot_number)
  end

  def self.for_lot_and_regions(lot_number, region_codes)
    where(lot_number: lot_number, region_code: region_codes)
  end
end
