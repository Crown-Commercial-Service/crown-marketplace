module Geolocatable
  extend ActiveSupport::Concern

  DEFAULT_SEARCH_RANGE_IN_MILES = 25

  included do
    attribute :postcode
    validates :location, location: true

    attribute :radius, Integer, default: DEFAULT_SEARCH_RANGE_IN_MILES
  end

  def location
    @location ||= Location.new(postcode)
  end
end
