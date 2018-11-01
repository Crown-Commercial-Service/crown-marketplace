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
      .where(lot_number: lot_number)
      .map(&:supplier)
      .uniq
  end
end
