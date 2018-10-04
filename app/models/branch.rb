class Branch < ApplicationRecord
  belongs_to :supplier

  validates :postcode, presence: true, postcode: true

  def self.near(point, within_metres:)
    where(
      [
        'ST_DWithin(location, :point, :within_metres)',
        point: point, within_metres: within_metres
      ]
    )
  end
end
