class Supplier < ApplicationRecord
  has_many :supplier_frameworks, inverse_of: :supplier, class_name: 'Supplier::Framework', dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :duns_number, uniqueness: true, allow_nil: true
end
