class FacilitiesManagementSupplier < ApplicationRecord
  validates :name, presence: true
  validates :contact_name, presence: true
  validates :contact_email, presence: true
  validates :telephone_number, presence: true
end
