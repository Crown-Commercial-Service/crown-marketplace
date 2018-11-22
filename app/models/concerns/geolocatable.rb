module Geolocatable
  extend ActiveSupport::Concern

  included do
    attribute :postcode
    validates :location, location: true
  end

  def location
    @location ||= Location.new(postcode)
  end
end
