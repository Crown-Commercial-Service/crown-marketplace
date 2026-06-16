class Jurisdiction < ApplicationRecord
  belongs_to :framework, inverse_of: :jurisdictions

  has_many :supplier_framework_lot_jurisdictions, inverse_of: :jurisdiction, class_name: 'Supplier::Framework::Lot::Jurisdiction', dependent: :destroy

  scope :core, -> { where(framework_id: 'RM6360', category: 'core') }
  scope :non_core, -> { where(framework_id: 'RM6360', category: 'non-core') }

  scope :ordered_by_category_and_number, -> { order(:category, Arel.sql('LENGTH(id)'), Arel.sql('SUBSTRING(id FROM 4)')) }

  def self.regions_grouped_by_category(framework_id)
    jurisdictions = where(framework_id:)

    category_names = jurisdictions.pluck(:category).uniq

    jurisdictions.ordered_by_category_and_number.group_by(&:category).sort_by { |category_name, _jurisdictions| category_names.index(category_name) }
  end
end
