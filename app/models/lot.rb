class Lot < ApplicationRecord
  belongs_to :framework, inverse_of: :lots

  has_many :services, inverse_of: :lot, dependent: :destroy
  has_many :positions, inverse_of: :lot, dependent: :destroy
  has_many :supplier_framework_lots, inverse_of: :lot, class_name: 'Supplier::Framework::Lot', dependent: :destroy
  has_many :procurements, inverse_of: :lot, dependent: :destroy

  def number_as_slug
    number.gsub('.', '-')
  end

  def self.find_by_number_as_slug(number_as_slug)
    find_by(number: number_as_slug.gsub('-', '.'))
  end

  def services_grouped_by_category
    category_names = services.pluck(:category)

    services.order(:name).group_by(&:category).sort_by { |category_name, _services| category_names.index(category_name) }
  end

  def positions_grouped_by_name
    position_names = positions.order(:number).pluck(:name)

    positions.order(:number).group_by(&:name).sort_by { |position_name, _position| position_names.index(position_name) }
  end
end
