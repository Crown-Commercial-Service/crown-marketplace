class Procurement < ApplicationRecord
  belongs_to :user, inverse_of: :procurements
  belongs_to :framework, inverse_of: :procurements
  belongs_to :lot, inverse_of: :procurements

  with_options on: :contract_name do
    before_validation :remove_excess_whitespace_from_name
    validates :contract_name, presence: true
    validates :contract_name, uniqueness: { scope: %i[user framework] }
    validates :contract_name, length: 1..100
  end

  private

  def remove_excess_whitespace_from_name
    contract_name&.squish!
  end

  def attribute_getter(attribute, default_value)
    procurement_details&.dig(attribute).nil? ? default_value : procurement_details&.dig(attribute)
  end

  def attribute_setter(attribute, value, cast_func = nil)
    self.procurement_details ||= {}

    self.procurement_details[attribute] = cast_func.nil? ? value : cast_func.call(value)
  end
end
