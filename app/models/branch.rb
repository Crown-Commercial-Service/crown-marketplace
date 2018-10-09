class Branch < ApplicationRecord
  DEFAULT_SEARCH_RANGE_IN_MILES = 25

  belongs_to :supplier

  validates :postcode, presence: true, postcode: true
  validates :contact_name, presence: true
  validates :contact_email, presence: true

  before_save :clear_geocoding
  after_save :geocode

  def self.near(point, within_metres:)
    where(
      [
        'ST_DWithin(location, :point, :within_metres)',
        point: point, within_metres: within_metres
      ]
    )
  end

  private

  def clear_geocoding
    return if new_record?

    return unless attribute_changed?(:postcode)

    self.location = nil
  end

  def geocode
    return unless location.nil?

    GeocodingJob.perform_now(self)
  end
end
