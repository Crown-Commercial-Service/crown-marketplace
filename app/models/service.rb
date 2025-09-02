class Service < ApplicationRecord
  belongs_to :lot, inverse_of: :services

  has_many :supplier_framework_lot_services, inverse_of: :service, class_name: 'Supplier::Framework::Lot::Service', dependent: :destroy
end
