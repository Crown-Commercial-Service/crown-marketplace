class FacilitiesManagementServiceOffering < ApplicationRecord
  belongs_to :supplier,
             class_name: 'FacilitiesManagementSupplier',
             foreign_key: :facilities_management_supplier_id,
             inverse_of: :service_offerings

  validates :lot_number, presence: true
  validates :service_code, presence: true

  def self.for_lot(lot_number)
    where(lot_number: lot_number)
  end

  def service
    FacilitiesManagementService.find_by(code: service_code)
  end
end
