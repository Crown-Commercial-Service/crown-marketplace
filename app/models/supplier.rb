class Supplier < ApplicationRecord
  has_many :branches, dependent: :destroy

  validates :name, presence: true
end
