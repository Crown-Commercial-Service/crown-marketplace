class Lot < ApplicationRecord
  belongs_to :framework, inverse_of: :lots

  has_many :services, inverse_of: :lot, dependent: :destroy
  has_many :supplier_framework_lots, inverse_of: :lot, class_name: 'Supplier::Framework::Lot', dependent: :destroy

  def services_grouped_by_category
    category_names = services.pluck(:category)

    services.order(:name).group_by(&:category).sort_by { |category_name, _services| category_names.index(category_name) }
  end
end
