class Jurisdiction < ApplicationRecord
  has_many :supplier_framework_lot_jurisdictions, inverse_of: :jurisdiction, class_name: 'Supplier::Framework::Lot::Jurisdiction', dependent: :destroy

  scope :core, -> { where(category: 'core') }
  scope :non_core, -> { where(category: 'non-core') }

  scope :ordered_by_category_and_number, -> { order(:category, Arel.sql('LENGTH(id)'), Arel.sql('SUBSTRING(id FROM 4)')) }

  def self.regions_grouped_by_category
    jurisdictions = where.not(category: %i[core non-core])

    category_names = jurisdictions.pluck(:category).uniq

    jurisdictions.ordered_by_category_and_number.group_by(&:category).sort_by { |category_name, _jurisdictions| category_names.index(category_name) }
  end
end
