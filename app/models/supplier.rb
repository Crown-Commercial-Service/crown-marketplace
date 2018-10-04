class Supplier < ApplicationRecord
  has_many :branches, dependent: :destroy
end
