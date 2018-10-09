class Branch < ApplicationRecord
  DEFAULT_SEARCH_RANGE_IN_MILES = 25

  belongs_to :supplier

  validates :postcode, presence: true, postcode: true
  validates :contact_name, presence: true
  validates :contact_email, presence: true

  def self.near(point, within_metres:)
    where(
      [
        'ST_DWithin(location, :point, :within_metres)',
        point: point, within_metres: within_metres
      ]
    )
  end
end
