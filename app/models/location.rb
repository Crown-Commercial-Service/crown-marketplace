class Location
  attr_reader :postcode, :point

  def initialize(postcode)
    @postcode = UKPostcode.parse(postcode)
    @point = Geocoding.new.point(postcode: @postcode.to_s) if @postcode.valid?
  end

  def valid?
    @postcode.valid?
  end
end
