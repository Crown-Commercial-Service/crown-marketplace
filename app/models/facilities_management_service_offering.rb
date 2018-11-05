class FacilitiesManagementServiceOffering < ApplicationRecord
  belongs_to :supplier,
             class_name: 'FacilitiesManagementSupplier',
             foreign_key: :facilities_management_supplier_id,
             inverse_of: :service_offerings

  validates :lot_number, presence: true
  validates :service_code, presence: true
end
