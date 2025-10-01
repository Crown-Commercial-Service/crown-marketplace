class Jurisdiction < ApplicationRecord
  has_many :supplier_framework_lot_jurisdictions, inverse_of: :jurisdiction, class_name: 'Supplier::Framework::Lot::Jurisdiction', dependent: :destroy

  scope :core, -> { where(category: 'core') }
  scope :non_core, -> { where(category: 'non-core') }

  scope :ordered_by_category_and_number, -> { order(:category, Arel.sql('LENGTH(id)'), Arel.sql('SUBSTRING(id FROM 4)')) }
end
