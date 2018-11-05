class FacilitiesManagementSupplier < ApplicationRecord
  has_many :regional_availabilities,
           class_name: 'FacilitiesManagementRegionalAvailability',
           inverse_of: :supplier,
           dependent: :destroy

  validates :name, presence: true
  validates :contact_name, presence: true
  validates :contact_email, presence: true
  validates :telephone_number, presence: true

  def self.available_in_lot(lot_number)
    FacilitiesManagementRegionalAvailability
      .includes(:supplier)
      .merge(FacilitiesManagementRegionalAvailability.for_lot(lot_number))
      .map(&:supplier)
      .uniq
  end

  def self.available_in_lot_and_regions(lot_number, region_codes)
    all.select { |s| s.serves_all?(lot_number, region_codes) }
  end

  def serves_all?(lot_number, region_codes)
    (region_codes - regional_availabilities.for_lot(lot_number).map(&:region_code)).empty?
  end
end
