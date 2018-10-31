class FacilitiesManagementSupplier < ApplicationRecord
  validates :name, presence: true
  validates :contact_name, presence: true
end
