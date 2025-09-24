class Jurisdiction < ApplicationRecord
  has_many :supplier_framework_lot_jurisdictions, inverse_of: :jurisdiction, class_name: 'Supplier::Framework::Lot::Jurisdiction', dependent: :destroy
end
