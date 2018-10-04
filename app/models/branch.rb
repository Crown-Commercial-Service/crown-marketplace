class Branch < ApplicationRecord
  belongs_to :supplier

  validates :postcode, presence: true, postcode: true
end
