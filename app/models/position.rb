class Position < ApplicationRecord
  has_many :supplier_framework_lot_rates, inverse_of: :position, class_name: 'Supplier::Framework::Lot::Rate', dependent: :destroy
end
